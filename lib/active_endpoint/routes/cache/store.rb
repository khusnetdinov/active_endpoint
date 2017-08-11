module ActiveEndpoint
  module Routes
    module Cache
      class Store
        delegate :read, to: :@store
        delegate :write, to: :@store
        delegate :expires_in, to: :@store

        def initialize
          @store = ActiveEndpoint::Routes::Cache::Proxy.build(ActiveEndpoint.cache_store_client)
          @logger = ActiveEndpoint.logger
          @notifier = ActiveSupport::Notifications
        end

        def allow?(rule)
          rule_cache_allow?(rule) && storage_cache_allow?(rule)
        end

        def unregistred?(probe)
          path = probe[:path]
          read(path).present? ? false : write(path, :unregistred)
        end

        private

        def rule_cache_allow?(options)
          cache_allow?(:rule, options)
        end

        def storage_cache_allow?(options)
          cache_allow?(:storage, options) do |key, period|
            expired = {
              key: key,
              period: period
            }

            @notifier.instrument('active_endpoint.clean_expired', expired: expired)
          end
        end

        def cache_allow?(prefix, options, &block)

          key = "#{prefix}:#{options[:key]}"
          constraints = options[prefix]

          cache = read(key)
          limit = cache.nil? ? cache : cache.to_i
          period = expires_in(key)

          if ActiveEndpoint.log_debug_info
            @logger.debug('ActiveEndpoint::Cache::Store Prefix', prefix)
            @logger.debug('ActiveEndpoint::Cache::Store Limit', limit)
            @logger.debug('ActiveEndpoint::Cache::Store Period', period)
          end

          limited = limit.present? && limit.zero?
          expired = period.zero?

          if limit.nil? && expired && block_given?
            yield(options[:key], constraints[:period])
          end

          if limit.present? && !expired
            return false if limited
            write(key, limit - 1, period)
          else
            write(key, constraints[:limit] - 1, constraints[:period])
          end
        end
      end
    end
  end
end

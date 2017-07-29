module ActiveEndpoint
  module Routes
    module Cache
      class Store
        delegate :read, to: :@store
        delegate :write, to: :@store
        delegate :expires_in, to: :@store

        def initialize
          @store = ActiveEndpoint::Routes::Cache::Proxy.build(ActiveEndpoint.cache_store_client)
        end

        def allow?(rule)
          limit = read(rule[:key]).to_i
          period = expires_in(rule[:key])

          if limit.present? && period != 0
            return false if limit == 0

            write(rule[:key], limit - 1, period)
          else
            write(rule[:key], rule[:limit], rule[:period])
          end

          true
        end

        def unregistred?(probe)
          limit = read(probe[:path])

          if limit.present?
            false
          else
            write(probe[:path], :unregistred)
            true
          end
        end
      end
    end
  end
end

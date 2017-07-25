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
          limit = read(rule[:key])
          period = expires_in(rule[:key])

          if limit.present? && period != 0
            return false if limit == 0

            write(rule[:key], period, limit - 1)
          else
            write(rule[:key], rule[:period], rule[:limit])
          end

          true
        end
      end
    end
  end
end

module ActiveEndpoint
  module Routes
    module Cache
      module Proxy
        class RedisStoreProxy
          def initialize(cache_prefix = ActiveEndpoint.cache_prefix, store = ::Redis::Store.new)
            @prefix = cache_prefix
            @store = store
          end

          def read(unprefixed_key)
            @store.get("#{@prefix}:#{unprefixed_key}")
          end

          def write(unprefixed_key, value, expires_in = nil)
            store_key = store_key(unprefixed_key)

            if expires_in.present?
              @store.setex(store_key, expires_in, value)
            else
              @store.set(store_key, value)
            end

            true
          end

          def expires_in(unprefixed_key)
            time = @store.ttl(store_key(unprefixed_key)).to_i
            time == -1 || time == -2 ? 0 : time
          end

          private

          def store_key(unprefixed_key)
            "#{@prefix}:#{unprefixed_key}"
          end
        end
      end
    end
  end
end

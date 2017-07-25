module ActiveEndpoint
  module Routes
    module Cache
      module Proxy
        class RedisStoreProxy
          def initialize
            @prefix = ActiveEndpoint.cache_prefix
            @store = ::Redis::Store.new
          end

          def read(unprefixed_key)
            @store.get("#{@prefix}:#{unprefixed_key}").to_i
          rescue Redis::BaseError
          end

          def write(unprefixed_key, expires_in, value)
            @store.setex("#{@prefix}:#{unprefixed_key}", expires_in, value)
          rescue Redis::BaseError
          end

          def expires_in(unprefixed_key)
            time = @store.ttl("#{@prefix}:#{unprefixed_key}").to_i
            time == -1 || time == -2 ? 0 : time
          rescue Redis::BaseError
          end
        end
      end
    end
  end
end

module ActiveEndpoint
  module Routes
    module Cache
      module Proxy
        class AdapterError < ::StandardError; end

        CLIENTS = {
          redis: 'RedisStoreProxy'
        }.freeze

        def self.build(adapter)
          unless CLIENTS.keys.include?(adapter)
            message "You try to use unsupported cache store adapter! #{adapter}\n"
            raise ActiveEndpoint::Routes::Cache::Proxy::AdapterError.new(message)
          end

          "ActiveEndpoint::Routes::Cache::Proxy::#{CLIENTS[adapter]}".constantize.new
        end
      end
    end
  end
end

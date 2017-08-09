module ActiveEndpoint
  module Routes
    module Cache
      module Proxy
        require 'active_support/core_ext'

        class AdapterError < ::StandardError; end

        CLIENTS = {
          redis: 'RedisStoreProxy'
        }.freeze

        def self.build(adapter)
          if CLIENTS.keys.exclude?(adapter)
            message "You try to use unsupported cache store adapter! #{adapter}\n"
            raise ActiveEndpoint::Routes::Cache::Proxy::AdapterError.new(message)
          end

          "ActiveEndpoint::Routes::Cache::Proxy::#{CLIENTS[adapter]}".constantize.new
        end
      end
    end
  end
end

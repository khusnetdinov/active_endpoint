require 'active_endpoint/rails/middleware'
require 'active_endpoint/rails/railtie' if defined?(Rails)
require 'active_endpoint/configuration/config'
require 'active_endpoint/configuration/tags_builder'
require 'active_endpoint/configuration/tag'
require 'pry'

module ActiveEndpoint
  class << self
    def configuration
      @configuration ||= Configuration::Config.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end
end


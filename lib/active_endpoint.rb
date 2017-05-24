require "active_endpoint/version"
require "active_endpoint/concerns/configurable"

module ActiveEndpoint
  extend Configurable

  define_setting :settings, "default"
end

require "active_endpoint/rails/railtie" if defined?(Rails)


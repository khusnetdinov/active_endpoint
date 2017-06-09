require "active_endpoint/version"
require "active_endpoint/concerns/configurable"
require "active_endpoint/routes/blacklist"

module ActiveEndpoint
  extend Configurable

  define_setting :blacklist, ActiveEndpoint::Routes::Blacklist.new
end

require "active_endpoint/rails/railtie" if defined?(Rails)

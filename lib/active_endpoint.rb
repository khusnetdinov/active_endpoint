require 'base64'
require 'rack'
require 'rack/request'
require 'active_support/time'
require 'active_support/core_ext/module/delegation'

require 'active_endpoint/concerns/configurable'
require 'active_endpoint/concerns/optionable'
require 'active_endpoint/concerns/rails_routable'
require 'active_endpoint/routes/blacklist'
require 'active_endpoint/routes/constraints'
require 'active_endpoint/routes/matcher'
require 'active_endpoint/routes/cache/proxy/redis_store_proxy'
require 'active_endpoint/routes/cache/proxy'
require 'active_endpoint/routes/cache/store'
require 'active_endpoint/proxy'
require 'active_endpoint/request'
require 'active_endpoint/response'
require 'active_endpoint/storage'
require 'active_endpoint/tags'
require 'active_endpoint/version'

module ActiveEndpoint
  extend Configurable

  define_setting :blacklist, ActiveEndpoint::Routes::Blacklist.new

  define_setting :cache_store_client, :redis
  define_setting :cache_prefix, 'active_endpoint'

  define_setting :constraint_limit, 10
  define_setting :constraint_period, 2.minutes
  define_setting :constraints, ActiveEndpoint::Routes::Constraints.new

  define_setting :favicon, '/favicon.ico'

  define_setting :storage_limit, 1000
  define_setting :storage_period, 1.day
  define_setting :storage_keep_periods, 2

  # define_setting :tags, ActiveEndpoint::Tags.new
end

if defined?(::Rails)
  require 'active_endpoint/rails/middleware'
  require 'active_endpoint/rails/railtie'

  require 'models/probe'
  require 'models/unregistred_probe'

  require 'rails/generators'
  require 'rails/generators/migration'
end

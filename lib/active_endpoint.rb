require "rack"
require "active_support/time"

require "active_endpoint/concerns/configurable"
require "active_endpoint/concerns/optionable"
require "active_endpoint/concerns/rails_routable"
require "active_endpoint/routes/blacklist"
require "active_endpoint/routes/constraints"
require "active_endpoint/routes/matcher"
require "active_endpoint/probe"
require "active_endpoint/request"
require "active_endpoint/response"
require "active_endpoint/storage"
require "active_endpoint/tags"
require "active_endpoint/version"

module ActiveEndpoint
  extend Configurable

  define_setting :blacklist, ActiveEndpoint::Routes::Blacklist.new

  define_setting :favicon, '/favicon.ico'

  define_setting :constraint_limit, 10
  define_setting :constraint_period, 2.minutes
  define_setting :constraints, ActiveEndpoint::Routes::Constraints.new

  # define_setting :storage, :postgres
  # define_setting :storage_amount, 100
  # define_setting :storage_period, 1.week

  # define_setting :tags, ActiveEndpoint::Tags.new
end

if defined?(Rails)
  require "active_endpoint/rails/middleware"
  require "active_endpoint/rails/railtie"
end

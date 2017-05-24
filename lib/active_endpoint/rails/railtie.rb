require "active_endpoint/rails/middleware"

module ActiveEndpoint
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "active_endpoint.configure_rails_initialization" do |app|
        app.middleware.insert(0, ActiveEndpoint::Rails::Middleware)
      end
    end
  end
end

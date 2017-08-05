module ActiveEndpoint
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'active_endpoint.configure_rails_initialization' do |app|
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.send(:extend, ::ActiveEndpoint::Extentions::ActiveRecord)
        end

        app.middleware.insert(0, ActiveEndpoint::Rails::Middleware)
      end
    end
  end
end

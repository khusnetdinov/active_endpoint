module ActiveEndpoint
  class Engine < ::Rails::Engine
    isolate_namespace ActiveEndpoint

    initializer 'active_endpoint.assets.precompile' do |app|
      app.config.assets.precompile += %w[]
    end

    config.generators do |g|
      g.orm :active_record
      g.template_engine :erb
      g.test_framework  :rspec
    end
  end
end

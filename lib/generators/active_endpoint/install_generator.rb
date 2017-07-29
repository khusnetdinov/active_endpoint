module ActiveEndpoint
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      puts '=> Creates a ActiveEndpoint initializer, migration and migrate data base for your application.'

      def copy_initializer_file
        puts '=> Copy initializer file to config/initializers/active_endpoint.rb'
        copy_file 'active_endpoint.rb', 'config/initializers/active_endpoint.rb'
      end

      def copy_migration_file
        puts '=> Create migration file in db/migrate/***_create_active_endpoint_probe.rb'
        copy_file 'migration.rb', "db/migrate/#{Time.current.strftime('%Y%m%d%H%M%S')}_create_active_endpoint_probes.rb"
      end
    end
  end
end
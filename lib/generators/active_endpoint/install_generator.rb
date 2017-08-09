module ActiveEndpoint
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      source_root File.expand_path('../templates', __dir__)

      class << self
        def next_migration_number(_dirname)
          Time.current.strftime('%Y%m%d%H%M%S')
        end
      end

      puts '=> Creates a ActiveEndpoint initializer, migration and migrate data base for your application.'

      def copy_initializer_file
        puts '=> Copy initializer file to config/initializers/active_endpoint.rb'
        copy_file 'active_endpoint.rb', 'config/initializers/active_endpoint.rb'
      end

      def copy_migration_file
        puts '=> Create migration file in db/migrate/***_create_active_endpoint_probes.rb'
        migration_template 'migration.erb', 'db/migrate/create_active_endpoint_probes.rb',
                           migration_version: migration_version
      end

      private

      def migration_version
        last_rails = ::Rails.version.start_with?('5')
        "[#{::Rails::VERSION::MAJOR}.#{::Rails::VERSION::MINOR}]" if last_rails
      end
    end
  end
end

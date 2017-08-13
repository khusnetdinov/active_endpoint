module ActiveEndpoint
  module Routes
    class Matcher
      include RailsRoutable

      def initialize
        @blacklist = ActiveEndpoint.blacklist
        @cache_store = ActiveEndpoint::Routes::Cache::Store.new
      end

      def whitelisted?(request)
        trackable?(request) && rails_action?(request)
      end

      def blacklisted?(probe)
        @blacklist.include?(probe)
      end

      def unregistred?(request)
        trackable?(request) && !rails_action(request)
      end

      def assets?(request)
        request.path.start_with?('/assets')
      end

      def allow_account?(request)
        @constraint_rule = ActiveEndpoint::Routes::ConstraintRule.new(request).rule
        @cache_store.allow?(@constraint_rule)
      end

      def allow_register?(request)
        @cache_store.unregistred?(request.probe)
      end

      private

      def favicon?(request)
        request.path == '/favicon.ico'
      end

      def engine?(request)
        request.path.include?('active_endpoint')
      end

      def trackable?(request)
        !(engine?(request) || assets?(request) || favicon?(request) || blacklisted?(request.probe))
      end
    end
  end
end

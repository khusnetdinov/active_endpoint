module ActiveEndpoint
  module Routes
    class Matcher
      include RailsRoutable

      def initialize
        @blacklist = ActiveEndpoint.blacklist
        @cache_store = ActiveEndpoint::Routes::Cache::Store.new
        @constraints = ActiveEndpoint.constraints
        @favicon = ActiveEndpoint.favicon
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
        @cache_store.allow?(@constraints.rule(request))
      end

      private

      def favicon?(request)
        (request.path == '/favicon.ico') || (request.path == @favicon)
      end

      def trackable?(request)
        !(assets?(request) || favicon?(request) || blacklisted?(request.probe))
      end
    end
  end
end

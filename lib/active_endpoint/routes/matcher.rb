module ActiveEndpoint
  module Routes
    class Matcher
      include RailsRoutable

      def initialize
        @blacklist = ActiveEndpoint.blacklist
				@favicon = ActiveEndpoint.favicon
      end

      def whitelisted?(request)
        trackable?(request) && rails_action?(request)
      end

      def blacklisted?(request)
        @blacklist.include?(request)
      end

      def allowed?(request)
        true
      end

      def unregistred?(request)
        trackable?(request) && !rails_action(request)
      end

      def assets?(request)
        request.path.start_with?('/assets')
      end

      private

      def favicon?(request)
        (request.path == '/favicon.ico') || (request.path == @favicon)
      end

      def trackable?(request)
        !(assets?(request) || favicon?(request) || blacklisted?(request))
      end
    end
  end
end

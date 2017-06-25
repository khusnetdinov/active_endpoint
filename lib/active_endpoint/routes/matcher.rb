module ActiveEndpoint
  module Routes
    class Matcher
      include RailsRoutable

      def initialize
        @blacklist = ActiveEndpoint.blacklist
      end

      def whitelisted?(request)
        rails_action?(request) && !blacklisted?(request)
      end

      def blacklisted?(request)
        @blacklist.include?(request)
      end

      def allowed?(request)
        true
      end

      def unregistred?(request)
        !whitelisted?(request) && !blacklisted?(request) && !assets?(request)
      end

      def assets?(request)
        request.path.start_with?('/assets')
      end
    end
  end
end

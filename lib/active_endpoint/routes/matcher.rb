module ActiveEndpoint
  module Routes
    class Matcher
      def initialize
        @blacklist = ActiveEndpoint.blacklist
      end

      def whitelisted?(request)
        defined_action?(request) && !blacklisted?(request)
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

      private

      def defined_action?(request)
        ::Rails.application.routes.recognize_path(request.path, method: request.method).present?
      rescue ActionController::RoutingError
        false
      end
    end
  end
end

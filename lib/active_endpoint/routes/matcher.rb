module ActiveEndpoint
  module Routes
    class Matcher
      def initialize
      end

      def whitelisted?(request)
        true
      end

      def allowed?(request)
        true
      end

      def blacklisted?(request)
        false
      end
    end
  end
end

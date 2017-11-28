module ActiveEndpoint
  class Logger
    class << self
      def info(caller, info)
        logger.info(message(caller, info))
      end

      def debug(caller, message)
        logger.debug(message(caller, message))
      end

      def error(caller, error)
        logger.error(message(caller, error))
      end

      private

      def logger
        ::Rails.logger
      end

      def message(caller, message)
        "ActiveEndpoint::Logger [#{caller}] - #{message}"
      end
    end
  end
end

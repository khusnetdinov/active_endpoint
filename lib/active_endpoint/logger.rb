module ActiveEndpoint
  class Logger
    class << self
      def info(caller, info, force)
        return if force.nil? || !force
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
        "ActiveEndpoint::Logger [#{caller.to_s}] - #{message}"
      end
    end
  end
end
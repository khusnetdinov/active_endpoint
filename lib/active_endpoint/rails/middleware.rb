require 'active_endpoint/probe_catcher'

module ActiveEndpoint
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        dup._call(env)
      end

      def _call(env)
        start = Time.now
        status, headers, response = @app.call(env)
        stop = Time.now

        duration = stop - start
        # TODO: process here

        [status, headers, response]
      end
    end
  end
end

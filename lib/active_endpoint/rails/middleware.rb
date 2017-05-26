require "active_endpoint/probe"

module ActiveEndpoint
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        dup._call(env, ActiveEndpoint::Probe.new)
      end

      def _call(env, probe)
        probe.track(env) { @app.call(env) }
      end
    end
  end
end

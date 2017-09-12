module ActiveEndpoint
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        dup._call(env, ActiveEndpoint::Proxy.new)
      end

      private

      def _call(env, proxy)
        proxy.track(env) { @app.call(env) }
      end
    end
  end
end

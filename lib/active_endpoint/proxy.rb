module ActiveEndpoint
  class Proxy
    def initialize
      @created_at = Time.now
      @matcher = ActiveEndpoint::Routes::Matcher.new
    end

    def track(env, &block)
      request = ActiveEndpoint::Request.new(env)

      # puts "ActiveEndpoint::Logger[Constraints!] #{ActiveEndpoint.constraints.inspect}"
      # puts "ActiveEndpoint::Logger[Tags!] #{ActiveEndpoint.tags.inspect}"

      if @matcher.whitelisted?(request)
        track_begin(request)
        status, headers, response = yield block
        track_end(response)
        [status, headers, response]
      else
        register(request) if @matcher.unregistred?(request)

        yield block
      end
    rescue => error
      # puts "ActiveEndpoint::Logger[Proxy::Error]: #{error}"

      yield block
    end

    private

    def track_begin(request)
      @request = request.probe
    end

    def track_end(response, finished_at = Time.now)
      @response = ActiveEndpoint::Response.new(response).probe
      @finished_at = finished_at

      ActiveSupport::Notifications.instrument('active_endpoint.tracked_probe', probe: {
        created_at: @created_at, finished_at: @finished_at, request: @request, response: @response
      }) if @matcher.allow_account?(@request)
    end

    def register(request)
      ActiveSupport::Notifications.instrument('active_endpoint.unregistred_probe', probe: {
        created_at: @created_at, finished_at: @finished_at, request: request.probe
      }) if @matcher.allow_register?(request)
    end
  end
end

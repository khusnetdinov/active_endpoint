module ActiveEndpoint
  class Proxy
    def initialize(matcher = ActiveEndpoint::Routes::Matcher.new)
      @matcher = matcher
      @created_at = Time.now
    end

    def track(env, &block)
      request = ActiveEndpoint::Request.new(env)

      ActiveEndpoint.logger.debug('ActiveEndpoint::Blacklist', ActiveEndpoint.blacklist)
      ActiveEndpoint.logger.debug('ActiveEndpoint::Constraints', ActiveEndpoint.constraints)

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
      @logger.error(self.class, error)

      yield block
    end

    private

    def track_begin(request)
      @request = request.probe
    end

    def track_end(response, finished_at = Time.now)
      @response = ActiveEndpoint::Response.new(response).probe
      @finished_at = finished_at

      probe = {
        created_at: @created_at,
        finished_at: @finished_at,
        request: @request,
        response: @response
      }

      ActiveSupport::Notifications.instrument('active_endpoint.tracked_probe', probe: probe) if @matcher.allow_account?(@request)
    end

    def register(request)
      unregistred = {
        created_at: @created_at,
        finished_at: @finished_at,
        request: request.probe
      }

      ActiveSupport::Notifications.instrument('active_endpoint.unregistred_probe', probe: unregistred) if @matcher.allow_register?(request)
    end
  end
end

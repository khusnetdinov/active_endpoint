require "active_endpoint/request"
require "active_endpoint/response"
require "active_endpoint/routes/matcher"

module ActiveEndpoint
  class Probe
    def initialize(matcher = ActiveEndpoint::Routes::Matcher.new)
      @created_at = Time.now
      @finished_at = nil
      @matcher = matcher
    end

    def track(env, &block)
      request = ActiveEndpoint::Request.new(env)

      if @matcher.whitelisted?(request) && @matcher.allowed?(request)
        track_begin(request)
        status, headers, response = yield block
        track_end(response)
        [status, headers, response]
      else
        account(request) unless @matcher.blacklisted?(request)
        yield block
      end
    end

    private

    def track_begin(request)
      # TODO: Save probe request
    end

    def track_end(response, finished_at = Time.now)
      response = ActiveEndpoint::Response.new(response)
      @finished_at = finished_at
      # TODO: Save probe response
      # TODO: Store probe
    end

    def unaccounted(request)
      # TODO: Store unaccounted probe
    end
  end
end

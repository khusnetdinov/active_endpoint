require "active_endpoint/request"
require "active_endpoint/response"
require "active_endpoint/routes/matcher"
require "active_endpoint/storage"

module ActiveEndpoint
  class Probe
    def initialize
      @created_at = Time.now
      @matcher = ActiveEndpoint::Routes::Matcher.new
      @storage = ActiveEndpoint::Storage.new
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
      @request = request.probe
    end

    def track_end(response, finished_at = Time.now)
      @response = ActiveEndpoint::Response.new(response).probe
      @finished_at = finished_at

      @storage.account({
        created_at: @created_at,
        finished_at: @finished_at,
        request: @request,
        response: @response,
      })
    end

    def unaccounted(request)
      @storage.register(request.probe)
    end
  end
end

module ActiveEndpoint
  class Response
    def initialize(response)
      @response = response
    end

    def probe
      {
        body: body
      }
    end

    def body
      @response.join if @response.respond_to? :join
    end
  end
end

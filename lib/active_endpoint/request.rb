module ActiveEndpoint
  class Request < Rack::Request
    include RailsRoutable

    def probe
      {
        base_url: base_url,
        body: body,
        content_charset: content_charset,
        content_length: content_length,
        content_type: content_type,
        endpoint: endpoint,
        fullpath: fullpath,
        http_version: http_version,
        http_connection: http_connection,
        http_accept_encoding: http_accept_encoding,
        http_accept_language: http_accept_language,
        ip: ip,
        media_type: media_type,
        media_type_params: media_type_params,
        method: method,
        params: params,
        path: path,
        path_info: path_info,
        pattern: pattern,
        port: port,
        protocol: protocol,
        query_string: query_string,
        request_method: request_method,
        server_name: server_name,
        ssl: ssl?,
        url: url,
        xhr: xhr?
      }
    end

    private

    def method
      request_method.downcase.to_sym
    end

    def endpoint
      action = rails_endpoint(self)
      return unless action
      "#{action[:controller]}##{action[:action]}"
    end

    def http_accept_encoding
      get_header('HTTP_ACCEPT_ENCODING')
    end

    def http_accept_language
      get_header('HTTP_ACCEPT_LANGUAGE')
    end

    def http_connection
      get_header('HTTP_CONNECTION')
    end

    def http_version
      get_header('HTTP_VERSION')
    end

    def params
      rails_request_params(self)
    end

    def pattern
      rails_route_pattern(self)
    end

    def protocol
      get_header('SERVER_PROTOCOL')
    end

    def server_name
      get_header('SERVER_NAME')
    end
  end
end

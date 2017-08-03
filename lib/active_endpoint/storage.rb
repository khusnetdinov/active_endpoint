module ActiveEndpoint
  class Storage
    private

    STORING_FIELDS = [
      :body,
      :response,
      :started_at,
      :finished_at,
      :duration,
      :endpoint,
      :ip,
      :params,
      :path,
      :request_method,
      :url,
      :xhr
    ].freeze

    LOGGING_FIELDS = [
      :base_url,
      :content_charset,
      :content_length,
      :content_type,
      :fullpath,
      :http_version,
      :http_connection,
      :http_accept_encoding,
      :http_accept_language,
      :media_type,
      :media_type_params,
      :method,
      :path_info,
      :pattern,
      :port,
      :protocol,
      :server_name,
      :ssl
    ].freeze

    def self.probe_params(transaction_id, probe)
      request = probe.delete(:request)
      request_body = request.delete(:body)

      response = probe.delete(:response)
      response_body = response.present? ? response[:body] : nil

      params = {
        uuid: transaction_id,
        response: response_body ? Base64.encode64(response_body) : '',
        started_at: probe[:created_at],
        finished_at: probe[:finished_at],
        duration: probe[:finished_at] ? (probe[:finished_at] - probe[:created_at]).second.round(3) : 0,
        body: request_body.is_a?(Puma::NullIO) ? '' : request_body
      }.merge(request)

      [params.dup.except(*LOGGING_FIELDS), params.dup.except(*STORING_FIELDS)]
    end

    def self.store!(params)
      handle_creation(ActiveEndpoint::Probe.new(params))
    end

    def self.register!(params)
      handle_creation(ActiveEndpoint::UnregistredProbe.new(params.merge(endpoint: :unregistred)))
    end

    def self.handle_creation(probe)
      probe.save
    rescue => error
      # puts "ActiveEndpoint::Logger Storage::Error: #{probe} - #{probe.error}"
    end

    def self.clean!(endpoint, period)
      ActiveEndpoint::Probe.registred.probe(endpoint).taken_before(period).destroy_all
    end

    ActiveSupport::Notifications.subscribe('active_endpoint.tracked_probe') do |_name, _start, _ending, transaction_id, payload|
      store_params, logging_params = probe_params(transaction_id, payload[:probe])

      # puts "ActiveEndpoint::Logger Storage::Info: #{logging_params}"

      store!(store_params)
    end

    ActiveSupport::Notifications.subscribe('active_endpoint.unregistred_probe') do |_name, _start, _ending, transaction_id, payload|
      store_params, logging_params = probe_params(transaction_id, payload[:probe])

      # puts "ActiveEndpoint::Logger Registration::Logging::Info: #{transaction_id} - #{logging_params}"
      # puts "ActiveEndpoint::Logger Registration::Storage::Info: #{transaction_id} - #{store_params}"

      register!(store_params)
    end

    ActiveSupport::Notifications.subscribe('active_endpoint.clean_expired') do |_name, _start, _ending, _transaction_id, payload|
      key = payload[:expired][:key].split(':').last
      period = DateTime.now - (payload[:expired][:period] * ActiveEndpoint.storage_keep_periods).seconds

      # puts "ActiveEndpoint::Logger Storage::Expired::Info #{key} ~ #{period}"

      clean!(key, period)
    end
  end
end

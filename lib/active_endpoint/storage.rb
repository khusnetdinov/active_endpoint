module ActiveEndpoint
  class Storage
    STORING_FIELDS = %i[
      body
      response
      started_at
      finished_at
      duration
      endpoint
      ip
      params
      path
      request_method
      url
      xhr
    ].freeze

    LOGGING_FIELDS = %i[
      base_url
      content_charset
      content_length
      content_type
      fullpath
      http_version
      http_connection
      http_accept_encoding
      http_accept_language
      media_type
      media_type_params
      method
      path_info
      pattern
      port
      protocol
      server_name
      ssl
    ].freeze

    class << self
      private

      def notifier
        ActiveSupport::Notifications
      end

      def store!(params)
        handle_creation(ActiveEndpoint::Probe.new(params))
      end

      def register!(params)
        handle_creation(ActiveEndpoint::UnregistredProbe.new(params.merge(endpoint: :unregistred)))
      end

      def clean!(endpoint, period)
        ActiveEndpoint::Probe.registred.probe(endpoint).taken_before(period).destroy_all
      end

      def handle_creation(probe)
        probe.save
      rescue => error
        ActiveEndpoint.logger.error('ActiveEndpoint::Probe', error)
      end

      def probe_params(transaction_id, probe)
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
    end

    notifier.subscribe('active_endpoint.tracked_probe') do |_name, _start, _ending, id, payload|
      store_params, logging_params = probe_params(id, payload[:probe])

      ActiveEndpoint.logger.info('ActiveEndpoint::Storage', logging_params, ActiveEndpoint.log_probe_info)

      store!(store_params)
    end

    notifier.subscribe('active_endpoint.unregistred_probe') do |_name, _start, _ending, id, payload|
      store_params, logging_params = probe_params(id, payload[:probe])

      ActiveEndpoint.logger.debug('ActiveEndpoint::Storage', store_params.inspect)
      ActiveEndpoint.logger.debug('ActiveEndpoint::Storage', logging_params.inspect)

      register!(store_params)
    end

    notifier.subscribe('active_endpoint.clean_expired') do |_name, _start, _ending, id, payload|
      key = payload[:expired][:key].split(':').last
      period = DateTime.now - (payload[:expired][:period] * ActiveEndpoint.storage_keep_periods).seconds

      ActiveEndpoint.logger.info('ActiveEndpoint::Storage', { key: key, period: period, uuid: id }.inspect)

      clean!(key, period)
    end
  end
end

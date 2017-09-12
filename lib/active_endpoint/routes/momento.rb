module ActiveEndpoint
  module Routes
    class Momento
      include Configurable
      include Optionable

      class Error < ::StandardError; end

      attr_reader :endpoints, :resources, :actions, :scopes

      def initialize(structure_class)
        @structure = structure_class
        @endpoints = structure_class.new
        @resources = structure_class.new
        @actions = structure_class.new
        @scopes = structure_class.new
      end

      def include?(request)
        [
          present_endpoint?(request),
          present_resource?(request),
          present_action?(request),
          present_scope?(request)
        ].any?
      end

      def add(**options, &block)
        yield(options) if block_given?

        add_endpoint(options) if fetch_endpoint(options).present?
        add_resources(options) if fetch_resources(options).present?
        add_scopes(options) if fetch_scope(options).present?
      end

      private

      def add_endpoint(_options)
        raise NotImplementedError
      end

      def add_resource(_options)
        raise NotImplementedError
      end

      def add_scopes(_options)
        raise NotImplementedError
      end

      def present_endpoint?(_request)
        raise NotImplementedError
      end

      def present_resource?(_request)
        raise NotImplementedError
      end

      def present_action?(_request)
        raise NotImplementedError
      end

      def present_scope?(_request)
        raise NotImplementedError
      end

      def apply(_scope, _collection)
        raise NotImplementedError
      end

      def check_present(collection, request)
        endpoint = request[:endpoint]
        collection.map { |subject| endpoint.present? && endpoint.start_with?(subject) }.any?
      end
    end
  end
end

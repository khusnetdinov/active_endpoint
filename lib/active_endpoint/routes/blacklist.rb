module ActiveEndpoint
  module Routes
    class Blacklist
      include Configurable
      include Optionable

      def initialize
        @endpoints = []
        @resources = []
        @actions = []
        @scopes = []
      end

      def include?(request)
        any_presented? [
          present_endpoint?(request),
          present_resource?(request),
          present_action?(request),
          present_scope?(request)
        ]
      end

      def exclude?(request)
        !include?(request)
      end

      def add(*options)
        options = parse(options)

        add_endpoint(options) if endpoint(options).present?
        add_resources(options) if resources(options).present?
        add_scopes(options) if scope(options).present?
      end

      def get_endpoints
        @endpoints
      end

      def get_resources
        @resources
      end

      def get_actions
        @actions
      end

      def get_scopes
        @scopes
      end

      private

      def add_endpoint(options)
        @endpoints << endpoint(options)
      end

      def add_resources(options)
        resources = resources(options)
        actions = actions(options)
        scope = scope(options)

        if actions.present? && actions.any?
          _actions = []
          if resources.is_a?(Array)
            resources.each do |controller_name|
              actions.each { |action| _actions << "#{controller_name}##{action}"}
            end
          else
            actions.each { |action| _actions << "#{resources}##{action}"}
          end
          @actions = @actions + apply(scope, _actions)
        else
          _resources = []
          if resources.is_a?(Array)
            resources.each { |resource| _resources << resource }
          else
            _resources << resources
          end
          @resources = @resources + apply(scope, _resources)
        end
      end

      def add_scopes(options)
        @scopes << scope(options)
      end

      def present_endpoint?(request)
        @endpoints.include?(request[:endpoint])
      end

      def present_resource?(request)
        reduce_state(@resources, request)
      end

      def present_action?(request)
        @actions.include?(request[:endpoint])
      end

      def present_scope?(request)
        reduce_state(@scopes, request)
      end

      def any_presented?(chain)
        chain.reduce(false) { |state, responder_state| state || responder_state }
      end

      def reduce_state(collection, request)
        collection.reduce(false) do |state, subject|
          state || request[:endpoint].present? && request[:endpoint].start_with?(subject)
        end
      end

      def apply(scope, collection)
        return collection unless scope.present?
        collection.map { |subject| "#{scope}/#{subject}" }
      end
    end
  end
end

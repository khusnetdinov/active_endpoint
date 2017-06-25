module ActiveEndpoint
  module Routes
    class Constraints
      include Configurable
      include Optionable

      def initialize
        @endpoints = {}
        @resources = {}
        @actions = {}
        @scopes = {}
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

      private

      def add_endpoint(options)
        @endpoints[endpoint(options)] = constraints(options)
      end

      def add_resources(options)
        resources = resources(options)
        actions = actions(options)
        scope = scope(options)

        if actions.present? && actions.any?
          _actions = {}
          if resources.is_a?(Array)
            resources.each do |controller_name|
              actions.each { |action| _actions["#{controller_name}##{action}"] = constraints(options) }
            end
          else
            actions.each { |action| _actions["#{resources}##{action}"] = constraints(options) }
          end
          @actions = @actions.merge(apply(scope, _actions))
        else
          _resources = {}
          if resources.is_a?(Array)
            resources.each { |resource| _resources[resource] = constraints(options) }
          else
            _resources[resources] = constraints(options)
          end
          @resources = @resources.merge(apply(scope, _resources))
        end
      end

      def add_scopes(options)
        @scopes[scope(options)] = constraints(options)
      end

      def present_endpoint?(request)
        @endpoints.keys.include?(request.endpoint)
      end

      def present_resource?(request)
        reduce_state(@resources.keys, request)
      end

      def present_action?(request)
        @actions.keys.include?(request.endpoint)
      end

      def present_scope?(request)
        reduce_state(@scopes.keys, request)
      end

      def any_presented?(chain)
        chain.reduce(false) { |state, responder_state| state || responder_state }
      end

      def reduce_state(collection, request)
        collection.reduce(false) do |state, subject|
          state || request.endpoint.start_with?(subject)
        end
      end

      def apply(scope, collection)
        return collection unless scope.present?

        collection.inject({}) do |hash, (key, value)|
          hash["#{scope}/#{key}"] = value
          hash
        end
      end

      def constraints(options)
        {
          limit: limit(options) || ActiveEndpoint.constraint_limit,
          period: period(options) || ActiveEndpoint.constraint_period
        }
      end
    end
  end
end

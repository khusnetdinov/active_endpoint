module ActiveEndpoint
  module Routes
    class Constraints
      include Configurable
      include Optionable

      class Error < ::StandardError; end

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

        if limit(options).nil? && period(options).nil?
          message = "Constraints can't have empty limit and period!\n"
          raise ActiveEndpoint::Routes::Constraints::Error.new(message)
        end

        add_endpoint(options) if endpoint(options).present?
        add_resources(options) if resources(options).present?
        add_scopes(options) if scope(options).present?
      end

      # rule: start
      def rule(request)
        {
          key: "#{prefix(request)}:#{request[:endpoint]}"
        }.merge(fetch_constraints(request))
      end

      private

      def prefix(request)
        return :endpoints if present_endpoint?(request)
        return :resources if present_resource?(request)
        return :actions if present_action?(request)
        return :scopes if present_scope?(request)
        :defaults
      end

      def fetch_constraints(request)
        prefix = prefix(request)

        if prefix == :defaults
          default_constraints
        else
          constraints = instance_variable_get("@#{prefix}")[request[:endpoint]]
          constraints.present? ? constraints : default_constraints
        end
      end
      # rule: end

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
        @endpoints.keys.include?(request[:endpoint])
      end

      def present_resource?(request)
        reduce_state(@resources.keys, request)
      end

      def present_action?(request)
        @actions.keys.include?(request[:endpoint])
      end

      def present_scope?(request)
        reduce_state(@scopes.keys, request)
      end

      def any_presented?(chain)
        chain.reduce(false) { |state, responder_state| state || responder_state }
      end

      def reduce_state(collection, request)
        collection.reduce(false) do |state, subject|
          state || request[:endpoint].start_with?(subject)
        end
      end

      def apply(scope, collection)
        return collection unless scope.present?

        collection.inject({}) do |hash, (key, value)|
          hash["#{scope}/#{key}"] = value
          hash
        end
      end

      # rule: start
      def constraints(options)
        {
          rule: rule_constraints(options),
          storage: storage_constraints(options)
        }
      end

      def default_constraints
        {
          rule: default_rule_constraints,
          storage: default_storage_constraints
        }
      end

      def rule_constraints(options)
        defined_rule_constraints = {
          limit: limit(options),
          period: period(options)
        }.compact

        default_rule_constraints.merge(defined_rule_constraints)
      end

      def storage_constraints(options)
        storage_options = storage(options)

        defined_storage_constraints = {
          limit: limit(storage_options),
          period: period(storage_options)
        }.compact

        default_storage_constraints.merge(defined_storage_constraints)
      end

      def default_rule_constraints
        {
          limit: ActiveEndpoint.constraint_limit,
          period: ActiveEndpoint.constraint_period
        }
      end

      def default_storage_constraints
        {
          limit: ActiveEndpoint.storage_limit,
          period: ActiveEndpoint.storage_period
        }
      end
      # rule: end
    end
  end
end

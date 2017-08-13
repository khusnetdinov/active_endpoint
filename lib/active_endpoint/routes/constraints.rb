module ActiveEndpoint
  module Routes
    class Constraints < Momento
      include Constraintable

      def initialize
        super(Hash)
      end

      def add(options)
        super(options) do |options|
          if fetch_rule(options).nil?
            message = "Constraints can't have empty limit and period!\n"
            raise ActiveEndpoint::Routes::Constraints::Error.new(message)
          end
        end
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

      private

      def add_endpoint(options)
        @endpoints[fetch_endpoint(options)] = constraints(options)
      end

      def add_resources(options)
        resources = fetch_resources(options)
        actions = fetch_actions(options)
        scope = fetch_scope(options)

        if actions.present? && actions.any?
          temp_actions = {}
          if resources.is_a?(Array)
            resources.each do |controller_name|
              actions.each { |action| temp_actions["#{controller_name}##{action}"] = constraints(options) }
            end
          else
            actions.each { |action| temp_actions["#{resources}##{action}"] = constraints(options) }
          end
          @actions = @actions.merge(apply(scope, temp_actions))
        else
          temp_resources = {}
          if resources.is_a?(Array)
            resources.each { |resource| temp_resources[resource] = constraints(options) }
          else
            temp_resources[resources] = constraints(options)
          end
          @resources = @resources.merge(apply(scope, temp_resources))
        end
      end

      def add_scopes(options)
        @scopes[fetch_scope(options)] = constraints(options)
      end

      def apply(scope, collection)
        return collection unless scope.present?

        collection.inject({}) do |hash, (key, value)|
          hash["#{scope}/#{key}"] = value
          hash
        end
      end
    end
  end
end

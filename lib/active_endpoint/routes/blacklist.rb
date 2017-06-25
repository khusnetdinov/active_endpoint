module ActiveEndpoint
  module Routes
    class Blacklist
      include Configurable
      include RailsRoutable

      def initialize
        @endpoints = []
        @resources = []
        @actions = []
        @scopes = []
      end

      def include?(request)
        ignored? [
          ignored_endpoint?(request),
          ignored_resource?(request),
          ignored_action?(request),
          ignored_scope?(request)
        ]
      end

      def add(*options)
        options = parse(options)

        ignore_endpoint(options) if endpoint(options).present?
        ignore_resources(options) if resources(options).present?
        ignore_scopes(options) if scope(options).present?
      end

      private

      def parse(options)
        options.inject({}) do |hash, option|
          hash[options.first] = options.last
        end
      end

      def endpoint(options)
        options[:endpoint]
      end

      def actions(options)
        options[:actions]
      end

      def resources(options)
        options[:resources]
      end

      def scope(options)
        options[:scope]
      end

      def ignore_endpoint(options)
        @endpoints << endpoint(options)
      end

      def ignore_resources(options)
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

      def ignore_scopes(options)
        @scopes << scope(options)
      end

      def ignored?(blockers)
        blockers.reduce(false) { |state, blocker| state || blocker }
      end

      def ignored_endpoint?(request)
        @endpoints.include?(request.probe[:endpoint])
      end

      def ignored_resource?(request)
        reduce_state(@resources, request)
      end

      def ignored_action?(request)
        @actions.include?(request.probe[:endpoint])
      end

      def ignored_scope?(request)
        reduce_state(@scopes, request)
      end

      def apply(scope, collection)
        scope.present? ? collection.map { |subject| "#{scope}/#{subject}" } : collection
      end

      def reduce_state(collection, request)
        collection.reduce(false) do |state, subject|
          state || request.probe[:endpoint].start_with?(subject)
        end
      end
    end
  end
end

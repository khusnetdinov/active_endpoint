module ActiveEndpoint
  module Routes
    class Blacklist < Momento
      def initialize
        super(Array)
      end

      private

      def add_endpoint(options)
        @endpoints << fetch_endpoint(options)
      end

      def add_resources(options)
        resources = fetch_resources(options)
        actions = fetch_actions(options)
        scope = fetch_scope(options)

        if actions.present? && actions.any?
          temp_actions = []
          if resources.is_a?(Array)
            resources.each do |controller_name|
              actions.each { |action| temp_actions << "#{controller_name}##{action}" }
            end
          else
            actions.each { |action| temp_actions << "#{resources}##{action}" }
          end
          @actions += apply(scope, temp_actions)
        else
          temp_resources = []
          if resources.is_a?(Array)
            resources.each { |resource| temp_resources << resource }
          else
            temp_resources << resources
          end
          @resources += apply(scope, temp_resources)
        end
      end

      def add_scopes(options)
        scope = fetch_scope(options)
        @scopes << scope unless @scopes.include?(scope)
      end

      def present_endpoint?(request)
        @endpoints.include?(request[:endpoint])
      end

      def present_resource?(request)
        check_present(@resources, request)
      end

      def present_action?(request)
        @actions.include?(request[:endpoint])
      end

      def present_scope?(request)
        check_present(@scopes, request)
      end

      def apply(scope, collection)
        return collection unless scope.present?
        collection.map { |subject| "#{scope}/#{subject}" }
      end
    end
  end
end

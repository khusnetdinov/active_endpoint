module ActiveEndpoint
  module Routes
    class ConstraintRule
      include Optionable
      include Constraintable

      def initialize(request)
        @request = request
        @rules = ActiveEndpoint.constraints
      end

      def rule
        {
          key: "#{prefix}:#{@request[:endpoint]}"
        }.merge(fetch_constraints)
      end

      private

      def prefix
        return :endpoints if @rules.present_endpoint?(@request)
        return :resources if @rules.present_resource?(@request)
        return :actions if @rules.present_action?(@request)
        return :scopes if @rules.present_scope?(@request)
        :defaults
      end

      def fetch_constraints
        if prefix == :defaults
          default_constraints
        else
          constraints = @rules.public_send(prefix)[@request[:endpoint]]
          constraints.present? ? constraints : default_constraints
        end
      end
    end
  end
end

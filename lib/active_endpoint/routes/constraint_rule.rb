module ActiveEndpoint
  module Routes
    class ConstraintRule
      include Optionable
      include Constraintable

      def initialize(request, constraints = ActiveEndpoint.constraints)
        @request = request
        @constraints = constraints
      end

      def rule
        {
          key: "#{prefix}:#{@request[:endpoint]}"
        }.merge(fetch_constraints)
      end

      private

      def prefix
        return :endpoints if @constraints.send(:present_endpoint?, @request)
        return :resources if @constraints.send(:present_resource?, @request)
        return :actions if @constraints.send(:present_action?, @request)
        return :scopes if @constraints.send(:present_scope?, @request)
        :defaults
      end

      def fetch_constraints
        if prefix == :defaults
          default_constraints
        else
          constraints = @constraints.public_send(prefix)[@request[:endpoint]]
          constraints.present? ? constraints : default_constraints
        end
      end
    end
  end
end

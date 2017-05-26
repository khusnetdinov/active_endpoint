module ActiveEndpoint
  module Configuration
    class InvalidTag < StandardError; end

    class Tag
      include Comparable

      attr_reader :tag_names

      def initialize(tags, &block)
        @check_proc = block
        @tag_names = transform_to_array!(tags)
      end

      def <=>(other)
        if other.is_a?(Tag)
          @tag_names <=> other.tag_names
        else
          @tag_names <=> other
        end
      end

      private

      def transform_to_array!(tags)
        if tags.is_a?(String)
          [tags]
        elsif tags.is_a?(Array)
          tags
        else
          raise InvalidTag, 'Invalid tag type'
        end
      end
    end
  end
end

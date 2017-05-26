module ActiveEndpoint
  module Configuration
    class TagsBuilder
      attr_reader :tags

      def initialize
        @tags = []
      end

      def make(tags, &block)
        tag = Tag.new(tags, &block)
        @tags.push(tag)
      end

      def remove(removable)
        @tags.reject! { |tag| tag == removable }
      end
    end
  end
end

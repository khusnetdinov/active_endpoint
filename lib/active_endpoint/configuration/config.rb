module ActiveEndpoint
  module Configuration
    class Config
      attr_accessor :time_of_store, :black_list, :endpoints_to_analise
      attr_reader :tag_list, :probes_during_time

      def initialize
        @endpoints_to_analise = []
        @black_list = []
        @tag_list = []
        @time_of_store = nil
        @probes_during_time = OpenStruct.new(duration: nil, max_count: nil)
      end

      def tag_with
        tags_builder = TagsBuilder.new

        yield tags_builder if block_given?

        @tag_list = tags_builder.tags
      end

      def probes_during_time(duration:, max_count:)
        @probes_during_time = OpenStruct.new(duration: duration, max_count: count)
      end
    end
  end
end

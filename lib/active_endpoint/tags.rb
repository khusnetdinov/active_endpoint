module ActiveEndpoint
  class Tags
    include Configurable

    attr_reader :definition

    def initialize
      @definition = {}
    end

    def add(tag, condition)
      @definition[tag] = condition
    end
  end
end

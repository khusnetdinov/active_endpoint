module ActiveEndpoint
  module Routes
    class Blacklist
      include Configurable

			def initialize
				@list = {}
			end

			def include?(request)
				false
			end

			def add()
			end
		end
	end
end


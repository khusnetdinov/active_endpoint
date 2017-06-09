module ActiveEndpoint
  class Storage
    def account(request)
      puts "Accounted: #{request[:request]}"
    end

    def register(request)
      puts "Registered: #{request}"
    end
  end
end

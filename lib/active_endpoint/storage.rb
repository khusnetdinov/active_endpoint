module ActiveEndpoint
  class Storage
    def account(probe)
      puts "Accounted: #{probe}"
    end

    def register(probe)
      puts "Registered: #{probe}"
    end
  end
end

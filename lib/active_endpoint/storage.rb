module ActiveEndpoint
  class Storage
    def account(probe)
      puts "Accounted: #{probe}"
    end

    def register(probe)
      puts "Registered: #{probe}"
    end

    ActiveSupport::Notifications.subscribe('active_endpoint.tracked_probe') do |name, start, ending, transaction_id, payload|
      puts "Storeage.account!", name, start, ending, transaction_id, payload
    end

    ActiveSupport::Notifications.subscribe('active_endpoint.unregistred_probe') do |name, start, ending, transaction_id, payload|
      puts "Storeage.register!", name, start, ending, transaction_id, payload
    end
  end
end

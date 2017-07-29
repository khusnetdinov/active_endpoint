module RailsRoutable
  ACTION_KEYS = [:controller, :action]

  def rails_action?(request)
    rails_action(request).present?
  end

  def rails_route_pattern(request)
    rails_routes.router.recognize(request) do |route|
      return route.path.spec.to_s
    end
  rescue ActionController::RoutingError
    nil
  end

  def rails_request_params(request)
    action = rails_action(request)
    return unless action
    action.reject do |key, _value|
      ACTION_KEYS.include?(key)
    end
  end

  def rails_endpoint(request)
    action = rails_action(request)
    return unless action
    action.select do |key, _value|
      ACTION_KEYS.include?(key)
    end
  end

  def rails_endpoint_name(action)
    return unless action
    "#{action[:controller]}##{action[:action]}"
  end

  def rails_action(request)
    rails_routes.recognize_path(request.path, method: request.method)
  rescue ActionController::RoutingError
    nil
  end

  def rails_routes
    ::Rails.application.routes
  end
end

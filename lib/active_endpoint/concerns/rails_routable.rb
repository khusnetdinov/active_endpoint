module RailsRoutable
  ACTION_KEYS = [:controller, :action]

  def rails_action?(request)
    rails_action(request).present?
  rescue ActionController::RoutingError
    false
  end

  def rails_route_pattern(request)
    rails_routes.router.recognize(request) do |route|
      return route.path.spec.to_s
    end
  end

  def rails_request_params(request)
    rails_action(request).reject { |key, _value| ACTION_KEYS.include?(key) }
  end

  def rails_endpoint(request)
    rails_action(request).select { |key, _value| ACTION_KEYS.include?(key) }
  end

  def rails_endpoint_name(action)
    "#{action[:controller]}##{action[:action]}"
  end

  def rails_action(request)
    rails_routes.recognize_path(request.path, method: request.method)
  end

  def rails_routes
    ::Rails.application.routes
  end
end

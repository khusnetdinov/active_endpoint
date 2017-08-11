module Optionable
  private

  def fetch_endpoint(options)
    return nil unless options
    options[:endpoint]
  end

  def fetch_actions(options)
    return nil unless options
    options[:actions]
  end

  def fetch_resources(options)
    return nil unless options
    options[:resources]
  end

  def fetch_scope(options)
    return nil unless options
    options[:scope]
  end

  def fetch_limit(options)
    return nil unless options
    options[:limit]
  end

  def fetch_period(options)
    return nil unless options
    options[:period]
  end

  def fetch_storage(options)
    return nil unless options
    options[:storage]
  end

  def fetch_rule(options)
    return nil unless options
    options[:rule]
  end
end

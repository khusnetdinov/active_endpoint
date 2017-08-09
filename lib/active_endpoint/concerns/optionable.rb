module Optionable
  private

  def parse(options)
    options.inject({}) do |hash, _option|
      hash[options.first] = options.last
    end
  end

  def endpoint(options)
    return nil unless options
    options[:endpoint]
  end

  def actions(options)
    return nil unless options
    options[:actions]
  end

  def resources(options)
    return nil unless options
    options[:resources]
  end

  def scope(options)
    return nil unless options
    options[:scope]
  end

  def limit(options)
    return nil unless options
    options[:limit]
  end

  def period(options)
    return nil unless options
    options[:period]
  end

  def storage(options)
    return nil unless options
    options[:storage]
  end

  def rule(options)
    return nil unless options
    options[:rule]
  end
end

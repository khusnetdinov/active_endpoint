module Optionable
  private

  def parse(options)
    options.inject({}) do |hash, option|
      hash[options.first] = options.last
    end
  end

  def endpoint(options)
    options[:endpoint]
  end

  def actions(options)
    options[:actions]
  end

  def resources(options)
    options[:resources]
  end

  def scope(options)
    options[:scope]
  end

  def limit(options)
    options[:limit]
  end

  def period(options)
    options[:period]
  end

  def storage(options)
    options[:storage]
  end

  def rule(options)
    options[:rule]
  end
end

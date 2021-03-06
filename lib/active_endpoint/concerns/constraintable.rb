module Constraintable
  def constraints(options)
    {
      rule: rule_constraints(options),
      storage: storage_constraints(options)
    }
  end

  def rule_constraints(options)
    rule_options = fetch_rule(options)

    defined_rule_constraints = {
      limit: fetch_limit(rule_options),
      period: fetch_period(rule_options)
    }.reject { |_key, value| value.nil? }

    default_rule_constraints.merge(defined_rule_constraints)
  end

  def storage_constraints(options)
    storage_options = fetch_storage(options)

    defined_storage_constraints = {
      limit: fetch_limit(storage_options),
      period: fetch_period(storage_options)
    }.reject { |_key, value| value.nil? }

    default_storage_constraints.merge(defined_storage_constraints)
  end

  def default_constraints
    {
      rule: default_rule_constraints,
      storage: default_storage_constraints
    }
  end

  def default_rule_constraints
    {
      limit: ActiveEndpoint.constraint_limit,
      period: ActiveEndpoint.constraint_period
    }
  end

  def default_storage_constraints
    {
      limit: ActiveEndpoint.storage_limit,
      period: ActiveEndpoint.storage_period
    }
  end
end
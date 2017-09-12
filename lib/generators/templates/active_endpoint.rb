ActiveEndpoint.configure do |endpoint|
  endpoint.blacklist.configure do |list|
    # list.add(endpoint: 'web/welcome#index')
    # list.add(resources: 'web/users', actions: ['show'])
    # list.add(scope: 'web', resources: 'users', actions: ['show'])
    # list.add(scope: 'web')
  end

  endpoint.constraint_limit = 100
  endpoint.constraint_period = 1.minute

  endpoint.storage_limit = 1000
  endpoint.storage_period = 1.day
  endpoint.storage_keep_periods = 2

  endpoint.constraints.configure do |constraints|
    # constraints.add(endpoint: 'web/welcome#index',
    #   rule: { limit: 100, period: 1.minute },
    #   storage: { limit: 1000, period: 1.week }
    # })
    # constraints.add(scope: 'web', resources: 'users', rule: { limit: 100 })
    # constraints.add(scope: 'web', resources: ['users'],
    #   actions: [:show, :edit, :update],
    #   rule: { limit: 10, period: 1.minute })
    # constraints.add(scope: 'web', rule: { limit: 100, period: 1.minute })
  end

  endpoint.tags.configure do |tags|
    # tags.add(:fast, { less_than: 250 })
    # tags.add(:normal, { greater_than_or_equal_to: 250, less_than: 500 })
    # tags.add(:slow, { greater_than_or_equal_to: 250, less_than: 500 })
    # tags.add(:acceptable, { greater_than_or_equal_to: 500, less_than: 100 })
    # tags.add(:need_optimization, { greater_than_or_equal_to: 1000 })
  end

  define_setting :logger, ActiveEndpoint::Logger
end

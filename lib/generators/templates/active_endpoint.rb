ActiveEndpoint.configure do |endpoint|
  # endpoint.tags.configure do |tags|
  #   tags.define(:slow, ->(request) { request.runtime < 1000 })
  #   tags.define(:normal, ->(request) { request.runtime < 250 })
  #   tags.define(:fast, ->(request) { request.runtime < 50 })
  # end

  endpoint.blacklist.configure  do |list|
    # list.add(endpoint: 'web/welcome#index')
    # list.add(resources: 'web/users', actions: ['show'])
    # list.add(scope: 'web', resources: 'users', actions: ['show'])
    # list.add(scope: 'web')
  end

  endpoint.constraint_limit = 100
  endpoint.constraint_period = 1.minute

  endpoint.constraints.configure do |constraints|
    # constraints.add(endpoint: 'web/welcome#index', limit: 100, period: 1.minute, storage: {
    #   limit: 1000, period: 1.week
    # })
    # constraints.add(scope: 'web', resources: 'users', limit: 100)
    # constraints.add(scope: 'web', resources: ['users'], actions: [:show, :edit, :update], limit: 10, period: 1.minute)
    # constraints.add(scope: 'web', limit: 100, period: 1.minute)
  end

  endpoint.storage_limit = 1000
  endpoint.storage_period = 1.day
  endpoint.storage_keep_periods = 2
end
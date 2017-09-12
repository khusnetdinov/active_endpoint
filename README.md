# ActiveEndpoint [![Build Status](https://travis-ci.org/khusnetdinov/active_endpoint.svg?branch=master)](https://travis-ci.org/khusnetdinov/active_endpoint) [![Gem Version](https://badge.fury.io/rb/active_endpoint.svg)](https://badge.fury.io/rb/active_endpoint)

## Your request tracking tool for rails applications

## Attention! Gem in under active test and is preparing for first release !

![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/c_scale,w_346/v1501331806/github/active_probe.jpg)


## Usage

ActiveEndpoint is middleware for Rails applications that collects and analyses requests and responses per request for endpoint. It works with minimal impact on application's response time.

This gem uses `ActiveSupport::Notifications` and `Cache Storage` to reduce possible impact on application request / response processing time.

## Features

 - Metrics are stored in database for further tracking and analysis.
 - History rotation with configurable limits of records amount and age.
 - Routes filter (blacklist).
 - Probes tagging by processing time.

## Metrics

These endpoint metrics are stored in DB:

   - `:uuid` - uniq probe identifier
   - `:endpoint` - requested endpoint
   - `:path` - requested full path
   - `:query_string` - request query string
   - `:request_method` - http request method
   - `:ip` - ip address asked request
   - `:url` - request full url
   - `:xhr` - is request ajax?
   - `:started_at` - probe start time
   - `:finished_at` - probe finish time
   - `:duration` - probe request duration
   - `:params` - parsed requested params
   - `:response` - Base64 encoded html response
   - `:body` - Base64 encoded request body

Additional information is taken from Rack log:

`:base_url, :content_charset, :content_length, :content_type, :fullpath, :http_version, :http_connection, :http_accept_encoding, :http_accept_language, :media_type, :media_type_params, :method, :path_info, :pattern, :port, :protocol, :server_name, :ssl`.

Requests which are not recognized by rails router are stored as `unregistred`.

## Requirements

 - `redis` as cache storage

Be sure that you have all requrements installed on you machine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_endpoint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_endpoint

Setup project for using gem:

    $ rails generate active_endpoint:install

Migrate database for models:

    $ rake db:migrate  # Rails <=4
    $ rails db:migrate # Rails >=5

Now project has all files and settings that allow you to use gem.

## Configuration

### Endpoints filter (blacklist)

By default ActiveEndpoint treats all routes as `whitelist` routes. To filter some endpoints you can use `blackilist` configuration, as shown below:

```ruby
ActiveEndpoint.configure do |endpoint|
  endpoint.blacklist.configure  do |blacklist|
    # Ignore endpoint "welcome#index"
    blacklist.add(endpoint: "welcome#index")

    # Ignore "web/users" controller actions
    blacklist.add(resources: ["web/users"])

    # Ignore "web/users#show" action with scoped controller
    blacklist.add(scope: "web", resources: "users", actions: ["show"])

    # Ignore "admin" scope controllers
    blacklist.add(scope: "admin")
  end
end
```

#### Ignore one endpoint

`blacklist.add(endpoint: "users#index")` - Ignore one endpoint.

#### Ignore controller actions

`blacklist.add(resources: "users")` - Ignore all actions for `UsersController`.

`blacklist.add(resources: ["users", "managers"])` - Ignore all actions in `UsersController` and `ManagersController`.

`blacklist.add(resources: "users", actions: ["show"])` - Ignore only `show` action in `UsersController`.

#### Ignore namespace or scope

`blacklist.add(scope: "admin")` - Ignore all controllers and actions for `admin` namespace or scope.

### Constraints

You can specify the amount and period of request records to keep in database. Records which exceed these limits are automatically removed from database.
See example below:

 ```ruby
ActiveEndpoint.configure do |endpoint|
  # Defines default settings, 1 probe per 10 minutes for endpoint request
  constraint_limit = 1
  constraint_period = 10.minutes

  endpoint.constraints.configure  do |constraints|
    # Constraint endpoint "welcome#index" with 1 minute period and default limit
    # and configure database constraints to keep 1000 probes per 1 week.
    constraints.add(endpoint: "welcome#index",
      rule: { 1.minute },
      storage: { limit: 1000, period: 1.week })
    # Constraints "web/users" controller actions with custom limit and period
    # with defailt storage constraints
    constraints.add(resources: ["web/users"], rule: { limit: 100, period: 5.minutes })
  end
end
```
NOTE: To define a constraint you should define at least one limit or period.

### Storage settings

ActiveEndpoint creates two models in you rails application: `Probe` and it's child `UnregistredProbe`.
To prevent problems with database probes are removed when user defines custom period. Also you can limit storage probes in database.
It is recommended to define own storage default to prevent unwanted probes deletion. See example below:

```ruby
ActiveEndpoint.configure do |endpoint|
  # Define default limit for maximum probes amount
  endpoint.storage_limit = 1000

  # Define default period to keep probes in database.
  endpoint.storage_period = 1.week

  # Define amount of periods (constraint periods) that endpoints are kept in database.
  endpoint.storage_keep_periods = 2
end
```

### Tagging probes
You can group probes by tags automatically assigned according to request processing time (ms). See example below:

```ruby
ActiveEndpoint.configure do |endpoint|
  endpoint.tags.configure do |tags|
    tags.add(:fast, { less_than: 250 })
    tags.add(:normal, { greater_than_or_equal_to: 250, less_than: 500 })
    tags.add(:slow, { greater_than_or_equal_to: 500, less_than: 750 })
    tags.add(:acceptable, { greater_than_or_equal_to: 500, less_than: 1000 })
    tags.add(:need_optimization, { greater_than_or_equal_to: 1000 })
  end
end
```

#### Mehods for conditions

   - greater_than = '>'
   - greater_than_or_equal_to = '>=',
   - equal_to = '=',
   - less_than = '<',
   - less_than_or_equal_to = '<=',

#### Tagged model scopes

Defined tags are also usefull for scopes queries:

```ruby
ActiveEndpoint::Probe.tagged_as(:need_optimization)
#=> Returns all probes having corresponding tag and thus matching the condition
#   { greater_than_or_equal_to: 1000 }
```

#### Instance methods

Check tag on model:

```ruby
ActiveEndpoint::Probe.last.tag
#=> Returns probe's tag
```

### Web UI

ActiveEndpoint offer rails engine for managing probes. Mount it:

```ruby
  mount ActiveEndpoint::Engine => '/active_endpoint'
```

![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/v1502260319/github/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA_%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0_2017-08-09_%D0%B2_9.06.08_mmwh5d.png)

## License

This gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

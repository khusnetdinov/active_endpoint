# ActiveEndpoint [![Build Status](https://travis-ci.org/khusnetdinov/active_endpoint.svg?branch=master)](https://travis-ci.org/khusnetdinov/active_endpoint)
## You tracking request tool for rails applications

![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/c_scale,w_346/v1501331806/github/active_probe.jpg)


## Usage

ActiveEndpoint is middleware for Rails application that collects and analizes request and response per request for route endpoint. It works with minimum affecting to application response time.

It use `ActiveSupport::Notifications` and `Cache Storage` for reduction as possible affecting to application request / response.

Probes were taken from request are stored in database for tracking information. For preventing problems there are possibility to constraint time and period for taking request probes and create blacklist for endpoints in data storage and.

Information about endpoint probes that stores in data base:

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

Information for additional inspecting requets that only are logging from Rack:

`:base_url, :content_charset, :content_length, :content_type, :fullpath, :http_version, :http_connection, :http_accept_encoding, :http_accept_language, :media_type, :media_type_params, :method, :path_info, :pattern, :port, :protocol, :server_name, :ssl`.

If ActiveEndpoint get request what not recognizible by rails router it stores as `unregistred` endpoint.

## Requirements

    redis - as cache storage

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

Migrate data base for models:

    $ rake[rails] db:migrate

Now project have all files and settings that allow you to use gem.

## Configuration

### Blacklist probing endpoints

By default ActiveEndpoint set Rails application routes as `whitelist` routes, if you want to reduce endpoints for analizing use `blackilist` configuration, as shown below:

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

`baccklist.add(resoirces: ["users", "managers"])` - Ignore all actions for `UsersController` and `ManagersController`.

`blacklist.add(resoirces: "users", actions: ["show"])` - Ignore only `show` action for `UsersController`.

#### Ignore namespace or scope

`blacklist.add(scope: "admin")` - Ignore all controller and actions for `admin` namespace or scope.

### Favicon

`endpoint.favicon = custom_name.ico` - Use this if you have not `favicon.ico` name. Requires for ignoring request. Example:

```ruby
ActiveEndpoint.configure do |endpoint|
  endpoint.favicon = '/custom.ico'
end
```

### Constraints Time and Request limit for endpoint

By default ActiveEndpoint takes default settings for period and amount requests for limitation probes for given endpoints.
Additional you can specify how much probes you want to keep in database and how much probes you can store for endpoint in database per period.
After expiration storage constraints expired probes automaticaly are removed from data base. And you don't need care about it.
Also you can redefine them on constraining endpoint, see example below:

 ```ruby
ActiveEndpoint.configure do |endpoint|
  # Defines default settings, 1 probe per 10 minutes for endpoint request
  constraint_limit = 1
  constraint_period = 10.minutes

  endpoint.constraints.configure  do |constraints|
    # Constraint endpoint "welcome#index" with 1 minute period and default limit
    # and configure data base constraints for saving 1000 probes per 1 week.
    constraints.add(endpoint: "welcome#index",
      rule: { 1.minute },
      storage: { limit: 1000, period: 1.week })
    # Constraints "web/users" controller actions with custom limit and period
    # with defailt storage constraints
    constraints.add(resources: ["web/users"], rule: { limit: 100, period: 5.minutes })
  end
end
```
Warning!: For defining constraints you need at least define one of limit or period.

### Storage settings

ActiveEndpoint create two models in you rails application are `Probe` and STI child `UnregistredProbe`.
For preventing problems with database probes are removes after user defined period. Also you can limit storage probes in database.
Here you can see default settings for all constraints. For preventing removes actual probes define period that you want keep.
See example below:

```ruby
ActiveEndpoint.configure do |endpoint|
  # Define default limit for maximum amount storage in database for endpoint.
  endpoint.storage_limit = 1000

  # Define default period that models are kept in database. After this period they are destroyd. 
  endpoint.storage_period

  # Define amount periods (constraint periods) that endpoints are kept in database.
  endpoint.storage_keep_periods = 2
end
```

### Tagging probes
For analizing probes you can define tags for deviding probes in groups by duration of probe. Time is defined in milliseconds. See example:

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

Defined tags also usefull for scopes queries:

```ruby
ActiveEndpoint::Probe.tagged_as(:need_optimization)
#=> Returns all probes with truthy conditions { greater_than_or_equal_to: 1000 }
```

#### Instance methods

Check tag on model:

```ruby
ActiveEndpoint::Probe.last.tag
#=> Returns :need_optmization
```
### Logging

Logger settings:

```ruby
ActiveEndpoint.configure do |endpoint|
  # Logger
  define_setting :logger, ActiveEndpoint::Logger
  # Set true if you want log additional probe inf
  define_setting :log_probe_info, false
  # Set true for debugging, recomend for development
  define_setting :log_debug_info, false
end
```

### Web UI

ActiveEndpoint offer rails engine for managing probes. Mount it:

```ruby
  mount ActiveEndpoint::Engine => '/active_endpoint'
```

![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/v1502260319/github/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA_%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0_2017-08-09_%D0%B2_9.06.08_mmwh5d.png)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

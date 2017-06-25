# ActiveEndpoint [![Build Status](https://travis-ci.org/khusnetdinov/active_endpoint.svg?branch=master)](https://travis-ci.org/khusnetdinov/active_endpoint)

ActiveEndpoint is middleware for Rails application that collect and analize request and response per request for route endpoint. It works with minimum affecting to application response time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_endpoint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_endpoint

## Configuration

### Blacklist probing endpoints

By default ActiveEndpoint set Rails application routes as `whitelist` routes, if you want to reduce endpoints for analizing use `blackilist` configuration, as shown below:

```ruby
ActiveEndpoint.configure do |endpoint|
  endpoint.blacklist.configure  do |blacklist|
    #=> ignore endpoint "welcome#index"
    blacklist.add(endpoint: "welcome#index")
   
    #=> ignore "web/users" controller actions
    blacklist.add(resources: ["web/users"])
    
    #=> ignore "web/users#show" action with scoped controller
    blacklist.add(scope: "web", resources: "users", actions: ["show"])
    
    #=> ignore "admin" scope controllers
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

By default ActiveEndpoint takes default settings for time and amount requests for limitation probes for given endpoint. Also you can redifine them on constraining endpoint, see example below:
 
 ```ruby
ActiveEndpoint.configure do |endpoint|
  # Redefines default settings, 1 probe per 10 minutes for endpoint request
  constraint_limit = 1
  constraint_period = 10.minutes
  
  endpoint.constraints.configure  do |constraints|
    #=> constraint endpoint "welcome#index" with default period and limit
    constraints.add(endpoint: "welcome#index")
    
    #=> constraints "web/users" controller actions with custom limit and period
    constraints.add(resources: ["web/users"], period: 5.minutes, limit: 100)
  end
end
``` 

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

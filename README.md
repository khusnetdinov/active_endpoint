# ActiveEndpoint [![Build Status](https://travis-ci.org/khusnetdinov/active_endpoint.svg?branch=master)](https://travis-ci.org/khusnetdinov/active_endpoint)
## You tracking request tool for rails applications

![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/c_scale,w_346/v1501331806/github/active_probe.jpg)


## Usage

ActiveEndpoint is middleware for Rails application that collect and analize request and response per request for route endpoint. It works with minimum affecting to application response time.

It use `ActiveSupport::Notifications` and `Cache Storage` for reduction as possible affecting to application request / response.

Probes were taken from request are stored in database for tracking information. For preventing probles there are possibility to constraint time and period and create back list for endpoints for data storage and taking request probes.

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
 
Information for additional inspecting requets that only are logging from Rack: `:base_url, :content_charset, :content_length, :content_type, :fullpath, :http_version, :http_connection, :http_accept_encoding, :http_accept_language, :media_type, :media_type_params, :method, :path_info, :pattern, :port, :protocol, :server_name, :ssl`.

If ActiveEndpoint get request what not recognizible by rails router it stores as `unregistred` endpoint.

## Requirements

    * Redis - as cache storage
    
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
    #=> constraint endpoint "welcome#index" with 1 minute period and defaule limit
    constraints.add(endpoint: "welcome#index", 1.minute)
    
    #=> constraints "web/users" controller actions with custom limit and period
    constraints.add(resources: ["web/users"], period: 5.minutes, limit: 100)
  end
end
``` 
Warning!: For defining constraints you need at least define one of limit or period.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

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
    blacklist.add(endpoint: "welcome#index")
    #=> ignore endpoint "welcome#index"
    
    blacklist.add(resources: ["web/users"])
    #=> ignore "web/users" controller actions
    
    blacklist.add(scope: "web", resources: "users", actions: ["show"])
    #=> ignore "web/users#show" action with scoped controller
    
    blacklist.add(scope: "admin")
    #=> ignore "admin" scope controllers
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

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

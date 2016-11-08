# Funneler

A simple gem for helping coordinate moving a user through a set of
routes.  The gem uses a token to keep track of the current place in the funnel.
The simplest way to use that token is by including a module into the controller
and passing the token in the route. However since the token is simply a string
it can easily be kept in session or any other datastore if needed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'funneler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install funneler

## Usage

1. Add the gem to your web application.  The gem is not dependent upon
   any particular framework. It's only dependency is the [`jwt` gem](https://github.com/jwt/ruby-jwt]

2. Generate a token for a given set of routes, and route your user to
   the first page:
```ruby
funnel = Funneler.build(routes: ['/welcome', '/setup', '/complete'])
redirect_to funnel.first_page
```

3. Modify those pages to include the `Funneler::ControllerMethods`
   helper for reconstituting a funnel from the given token

4. Use the helper to determine the next page like this:
```erb
<%= link_to funnel.next_page, "Next" %>
```

## Details

The `Funneler::Funnel` is the core maintaining the state of the flow of
pages and building the paths with valid tokens.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/doximity/funneler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).

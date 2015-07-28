# Licode Ruby SDK

The Licode gem is designed to help you interface with the Licode platform via server side code.
It is influenced by the original `nuveClient_ruby` found in the ging/licode repo but isn't a gem and isn't easy to include in your projects.

This also will be more up to date and testable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'licode'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install licode

## Usage

### Initializing

Load the gem and initialize the `Licode::Nuve` object with your Licode `ServiceId`, `ServiceKey`, and `ServiceURL`.
Your service URL should be the server you have installed licode on either by `http://xxx.xxx.xxx.xxx:3000/` or if you reversed proxied via nginx.  (but you know that... right?)

```ruby
require "licode"

licode = Licode::Nuve.new "55b3f8d58591b4566af491ed", "18316", "http://my-licode-server:3000"
```

### Creating Rooms
Creating a room is done by the `Licode#create_room(name, options)` method.  The `name` parameter is up to you.  Pass in a hash or a unique identifier of your choosing to properly identify this room.  The `room_id` method of the returned `Licode::Room` instance is usually recommended to be persisted to a store (ie. database) for usage later when creating user tokens.

```ruby
# Creating a relayed (non-p2p) room.
room = licode.create_room('my-new-room', :p2p => false)

# Creating a p2p room which uses a TURN server to ensure proper connections between peers.
room = licode.create_room('my-new-room', :p2p => true)

# Store this room_id in the database for later generating user tokens.
room_id = room.room_id # 55b6549e0ff0f5c9551963c7
```

### Generating User Tokens
After creating a `Room`, your user's need a special unique `token` to connect to the room.
You may generate a token by either `licode.create_token(room_id,username,role)` or through an instance of `Licode::Room` after creating it either by `licode.create_room(name,options)` or `licode.client.get_room(room_id)`

```ruby
# Create a Token from just a room_id (fetched from a database)
token = licode.create_token session_id, 'my-user-id-name', 'presenter'

# Create a Token from a room instance.
room = licode.create_room('my-new-room') # or with `licode.client.get_room` but access to client might be deprecated later.

token = room.create_token('my-user-id-name','presenter') # roles are configured on your server in `licode_config.json` and by default are `presenter`, `viewer`, or `viewerWithData`
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshuairl/licode-ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

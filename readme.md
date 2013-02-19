# Esendex

Ruby Gem for interacting with the Esendex API

This is in very early stages of development but supports sending one or multiple messages using your account details

## Usage

### Setting up

From the command line

    gem install esendex

or in your project's Gemfile.

    gem 'esendex'

### Sending Messages

First instantiate an Account with your credentials

```ruby
    account = Account.new("EX123456", "user@company.com", "your_password")
```
	
then, call the send method on the account object with a message. The return value is a batch_id you can use to obtain the status of the messages you have sent.

```ruby
    batch_id = account.send_message(Message.new("07777111222", "Saying hello to the world with the help of Esendex"))
```

Multiple messages are sent by passing an array of Messages to the send_messages method
	
```ruby
    batch_id = account.send_messages([Message.new("07777111222", "Hello"), Message.new("07777111333", "Hi")])
```

## Building

The plan is to publish this so you can perform gem install but if you can't wait then feel free to download 

### Testing

		bundle exec rspec
	
will run specs, ie those in the root of the test folder

## Contributing

Please fork as you see fit and let us know when you have something that should be part of the gem.

## Copyright

Copyright (c) 2011-13 Esendex Ltd. See LICENSE.txt for further details.


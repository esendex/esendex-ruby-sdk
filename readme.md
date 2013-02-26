# Esendex

Ruby Gem for interacting with the Esendex API

This is in very early stages of development but supports sending one or multiple messages using your account details

## Usage

### Setting up

From the command line

    gem install esendex

or in your project's Gemfile.

    gem 'esendex'

Before sending messages you need to configure the gem with your credentials. In a Rails app this would typically go into a file called `esendex.rb` in the *config/initializers*.

```ruby
Esendex.configure do |config|
  config.username = "<username>"
  config.password = "<password>"
  config.account_reference = "<account_reference>"
end
```

You can omit account reference and specify it when you instantiate an account object if you're using multiple accounts.

You can also specify these using the environment variables `ESENDEX_USERNAME`, `ESENDEX_PASSWORD` and `ESENDEX_ACCOUNT`.

### Sending Messages

First instantiate an Account with the reference. You can omit the reference if you've already configured one to use in the *Esendex.configure* step.
Then, call the send method on the account object with a hash describing the message. The return value is a *batch_id* you can use to obtain the status of the messages you have sent.

```ruby
account = Account.new
batch_id = account.send_message( to: "07777111222", body: "Saying hello to the world with the help of Esendex")
```
You can specify a different account to the default by passing the reference in as an initialization argument

```ruby
account = Account.new('EX23847')
```

Multiple messages are sent by passing an array of `Messages` to the send_messages method
	
```ruby
batch_id = account.send_messages([Message.new("07777111222", "Hello"), Message.new("07777111333", "Hi")])
```

### Testing Configuration

The Esendex Gem ships with a couple of rake tasks that allow you to simply validate that all is well.

    rake esendex:validate['<username>,'<password>','<account_reference>']

This will confirm that the credentials passed can access the account.

You can also send a message

    rake esendex:send_message["<mobile_number>","<message_body>"]

You will need to set the credentials as enviroment variables which can also be done inline

    rake esendex:send_message["<mobile_number>","<message_body>"] ESENDEX_USERNAME=<username> ESENDEX_PASSWORD=<password> ESENDEX_ACCOUNT=<account_reference>


## Push Notifications

You can configure your account to send Push Notifications when the following occur

+ MessageDeliveredEvent
+ MessageFailedEvent
+ InboundMessage

While it is possible to poll our API to check the status of outbound messages and to check for new inbound messages, the recommended approach is to allow the Esendex Platform to notify your system when these events occur, if possible.

To do this you need to setup web accessible end points to accept the notifications. These end points are configured in [Esendex Developer Tools](https://www.esendex.com/developertools).

Classes are provided in the gem for deserialising `MessageDeliveredEvent`, `MessageFailedEvent` and `InboundMessage` all expose a `.from_xml` method to support this.

```ruby
InboundMessage.from_xml request.body
```

### Rails 3

In order to simplify receipt of push notifications for Rails 3 users, the gem ships with mountable Rails controllers to handle the receipt of these notifications.

To mount the end points, add this to `routes.rb`

```ruby
RailsApp::Application.routes.draw do
  ...
  mount Esendex::Engine => "/esendex"
end
```

To configure the behaviour in response to a notification, you need to configure a lambda to use.

```ruby
Esendex.message_delivered_event_handler = lambda { |notification| 
  # process the notification
}
```

Please be kind to us and don't perform anything potentially long running in this call back as this will 

The handlers are defined as follows

| End Point| Config Setting | Notification Class | Developer Tools |
| -------- | -------------- | ------------------ | --------------- |
| /esendex/inbound_messages | Esendex.inbound_message_handler | InboundMessage | SMS received |
| /esendex/message_delivered_events | Esendex.message_delivered_event_handler | MessageDeliveredEvent | SMS delivered |
| /esendex/message_failed_events | Esendex.message_failed_event_handler | MessageFailedEvent | SMS failed |

#### Errors

When errors occur in the handler lambdas then the controller returns a `500` status along with some error information back to the the Esendex Platform. This information is emailed to the technical notifications contact for the account.

The notification then enters the retry cycle. 

Included by default is the backtrace for the error to assist in identifying the issue. You can suppress backtrace with the following config option.

```ruby
Esendex.configure do |config|
  config.suppress_backtrace = true
end
```


## Contributing

Please fork as you see fit and let us know when you have something that should be part of the gem.

### Testing

    bundle exec rspec
  
will run specs, ie those in the root of the test folder

The spec folder contains a dummy Rails project for testing the Rails Engine.


## Copyright

Copyright (c) 2011-13 Esendex Ltd. See LICENSE.txt for further details.


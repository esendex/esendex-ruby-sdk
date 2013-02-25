require_relative '../esendex'
include Esendex

namespace :esendex do
  desc "Validates whether credentials are correct and returns message credit balance"
  task :validate, [:username, :password, :account_reference] do |t, args|
    begin
      Esendex.configure do |config|
        config.username = args.username
        config.password = args.password
        config.account_reference = args.account_reference
      end
      account = Account.new
      messages_remaining = account.messages_remaining
      puts "Validated user #{Esendex.username} on account #{account.reference}. #{messages_remaining} messages remaining"
    rescue => e
      puts "Failed to validate credentials #{e.message}"
    end
  end

  desc "Sends a message using the credentials specifed in the environment"
  task :send_message, [:to, :body, :from] do |t, args|
    begin
      account = Account.new
      batch_id = account.send_message(args)
      puts "Message sent to #{args.to}. Batch ID: #{batch_id}"
    rescue => e
      puts "Failed to send message #{e.message}"
    end
  end
end
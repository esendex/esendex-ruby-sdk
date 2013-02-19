require_relative '../lib/esendex'
include Esendex

namespace :esendex do
  task :validate, [:username, :password, :account_reference] do |t, args|
    begin
      Esendex.configure do |config|
        config.username = args.username
        config.password = args.password
        config.account_reference = args.account_reference
      end
      account = Account.new
      messages_remaining = account.messages_remaining
      puts "Valiated user #{Esendex.username} on account #{account.reference}. #{messages_remaining} messages remaining"
    rescue => e
      puts "Failed to validate credentials #{e.message}"
    end
  end

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
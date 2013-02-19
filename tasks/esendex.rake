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
      @account = Account.new
    rescue => e
      puts "Failed to validate credentials #{e.message}"
      e.backtrace.each do |l| puts l end
    end
    puts "Valiated user #{Esendex.username} on account #{@account.reference}. #{@account.messages_remaining} messages remaining"
  end

  task :send_message, [:to, :body] do |t, args|
    begin
      account = Account.new
      @batch_id = account.send_message(Message.new(args.to, args.body))
    rescue => e
      puts "Failed to send message #{e.message}"
    end
    puts "Message sent to #{args.to}. Batch ID: #{@batch_id}"
  end
end
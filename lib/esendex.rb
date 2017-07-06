module Esendex
  API_NAMESPACE = 'http://api.esendex.com/ns/'
  API_HOST = 'https://api.esendex.com'

  require_relative 'esendex/version'
  require_relative 'esendex/exceptions'
  require_relative 'esendex/api_connection'
  require_relative 'esendex/hash_serialisation'

  require_relative 'esendex/account'
  require_relative 'esendex/dispatcher_result'
  require_relative 'esendex/inbound_message'
  require_relative 'esendex/message'
  require_relative 'esendex/voice_message'
  require_relative 'esendex/message_batch_submission'
  require_relative 'esendex/message_delivered_event'
  require_relative 'esendex/message_status'
  require_relative 'esendex/message_failed_event'

  # Load Rails extensions if Rails present
  if defined?(Rails)
    require_relative 'esendex/railtie'
    require_relative 'esendex/engine'
  end

  # Public - used to configure the gem prior to use
  #
  #   Esendex.configure do |config|
  #     config.username = 'username'
  #     config.password = 'password'
  #     config.account_reference = 'account reference'
  #   end
  #
  def self.configure
    yield self if block_given?
  end

  class << self
    # credentials for authentication
    attr_writer :account_reference, :username, :password

    # lambdas for handling push notifications
    attr_accessor :message_delivered_event_handler, :message_failed_event_handler, :inbound_message_handler

    # behaviour config
    attr_accessor :suppress_error_backtrace

    def account_reference
      @account_reference ||= ENV['ESENDEX_ACCOUNT']
    end

    def username
      @username ||= ENV['ESENDEX_USERNAME']
    end

    def password
      @password ||= ENV['ESENDEX_PASSWORD']
    end
  end

  def self.user_agent
    "EsendexRubyGem/#{Esendex::VERSION}"
  end
end

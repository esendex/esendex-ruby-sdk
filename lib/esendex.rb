module Esendex
  require_relative 'esendex/version'
  require_relative 'esendex/api_connection'
  require_relative 'esendex/account'
  require_relative 'esendex/message'
  require_relative 'esendex/exceptions'
  require_relative 'esendex/message_batch_submission'
  
  require_relative 'esendex/railtie' if defined?(Rails)

  API_NAMESPACE = 'http://api.esendex.com/ns/'
  API_HOST = 'https://api.esendex.com'
  API_VERSION = 'v1.0'

  def self.configure
    yield self if block_given?

    unless Esendex.username
      raise StandardError.new("username required. Either set Esendex.username or set environment variable ESENDEX_USERNAME")
    end

    unless Esendex.password
      raise StandardError.new("password required. Either set Esendex.password or set environment variable ESENDEX_PASSWORD")
    end
  end

  class << self
    attr_writer :account_reference, :username, :password

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
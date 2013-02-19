module Esendex
  require 'nestful'

  require 'esendex/version'
  require 'esendex/account'
  require 'esendex/message'
  require 'esendex/exceptions'
  require 'esendex/message_batch_submission'
  
  API_NAMESPACE = 'http://api.esendex.com/ns/'

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
end
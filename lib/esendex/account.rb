require 'nestful'
require 'rexml/document'

module Esendex
  class Account
    attr_accessor :account_reference, :username, :password
    attr_reader :messages_remaining
    
    def initialize(account_reference, username, password, connection = Nestful::Connection.new('https://api.esendex.com'))
      @account_reference = account_reference
      @username = username
      @password = password

      @connection = connection
      @connection.user = @username
      @connection.password = @password
      @connection.auth_type = :basic
      
      begin
        response = @connection.get "/v0.1/accounts/#{@account_reference}"
        doc = REXML::Document.new(response.body)
        @messages_remaining = doc.elements["//accounts/account/messagesremaining"].text.to_i
      rescue Exception => exception
        raise ApiErrorFactory.new.get_api_error(exception)
      end
    end
    
    def send_message(message)
      self.send_messages([message])
    end
    
    def send_messages(messages)
      
      message_submission = MessageSubmission.new(@account_reference, messages)
      
      begin
        response = @connection.post "/v1.0/messagedispatcher", message_submission.to_s
        doc = REXML::Document.new(response.body)
        doc.root.attributes["batchid"]
      rescue Exception => exception
        raise ApiErrorFactory.new.get_api_error(exception)
      end
    end

  end
end

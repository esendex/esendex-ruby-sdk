require 'nestful'
require 'nokogiri'

module Esendex
  class Account
    attr_accessor :account_reference, :username, :password
    attr_reader :messages_remaining
    
    def initialize(account_reference = Esendex.account_reference, connection = Nestful::Connection.new('https://api.esendex.com'))
      @account_reference = account_reference

      @connection = connection
      @connection.user = Esendex.username
      @connection.password = Esendex.password
      @connection.auth_type = :basic
      
      begin
        response = @connection.get "/v0.1/accounts/#{@account_reference}"
        doc = Nokogiri::XML(response.body)
        @messages_remaining = doc.at_xpath('//api:accounts/api:account/api:messagesremaining', 'api' => Esendex::API_NAMESPACE).content.to_i
      rescue Exception => exception
        raise ApiErrorFactory.new.get_api_error(exception)
      end
    end
    
    def send_message(message)
      self.send_messages([message])
    end
    
    def send_messages(messages)
      
      batch_submission = MessageBatchSubmission.new(@account_reference, messages)
      
      begin
        response = @connection.post "/v1.0/messagedispatcher", batch_submission.to_s
        doc = Nokogiri::XML(response.body)
        doc.at_xpath('//api:messageheaders', 'api' => Esendex::API_NAMESPACE)['batchid']
      rescue Exception => exception
        raise ApiErrorFactory.new.get_api_error(exception)
      end
    end

  end
end

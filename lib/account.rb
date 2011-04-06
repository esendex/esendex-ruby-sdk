require 'nestful'
require 'rexml/document'

module Esendex
  class Account
    def initialize(account_reference, username, password)
      @account_reference = account_reference
      @username = username
      @password = password

      @connection = Nestful::Connection.new('https://api.esendex.com')
      @connection.user = @username
      @connection.password = @password
      @connection.auth_type = :basic
      
      response = @connection.get "/v0.1/accounts/#{@account_reference}"
      doc = REXML::Document.new(response.body)
      @messages_remaining = doc.elements["//accounts/account/messagesremaining"].text.to_i
    end
    
    def messages_remaining
      @messages_remaining
    end
    
    #<messages>
    #  <accountreference>EX000000</accountreference>
    #  <message>
    #    <to>$TO</to>
    #    <body>$BODY</body>
    #  </message>
    #</messages>
    
    def send(message)
      messages = Document.new "<messages/>" 
            
      account_reference = Element.new("accountreference")
      account_reference.text = @account_reference
      messages.root.elements << account_reference
      
      messages.root.elements << message.xml_node

      response = @connection.post "/v1.0/messagedispatcher", messages.to_s
    end
  end
end

require 'nokogiri'

module Esendex
  class SentMessageClient
    attr_accessor :api_connection

    def initialize(api_connection = ApiConnection.new)
      @api_connection = api_connection
    end

    def get_messages(account_reference = nil)
      response = api_connection.get "/v1.0/messageheaders?accountreference=#{URI.escape(account_reference)}"
      root = Nokogiri::XML.parse(response.body).root()
      messages = root.css('messageheader').map do |header|
        SentMessage.new({ 
          id: header['id'],
          status: header.at('status').text,
          status_at: DateTime.iso8601(header.at('laststatusat').text),
          submitted_by: header.at('username').text,
          submitted_at: DateTime.iso8601(header.at('submittedat').text),
          sent_at: DateTime.iso8601(header.at('sentat').text),
          delivered_at: DateTime.iso8601(header.at('deliveredat').text),
          from: header.at('from phonenumber').text,
          to: format_contact(header.at('to')),
          type: header.at('type').text,
          sms_parts: header.at('parts').text.to_i,
          summary: header.at('summary').text
        }, lambda { 
          response = api_connection.get(header.at('body')['uri'])
          Nokogiri::XML.parse(response.body).at('bodytext')
        })
      end
      SentMessagesResult.new root['startindex'].to_i, root['totalcount'].to_i, messages
    end

    def format_contact(contact_node)
      number = contact_node.at('phonenumber').text
      if contact_node.at('displayname').nil? then 
        number
      else 
        "#{contact_node.at('displayname').text} <#{number}>"
      end
    end

    private :format_contact
  end
end

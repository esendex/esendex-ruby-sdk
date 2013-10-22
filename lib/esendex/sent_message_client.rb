require 'nokogiri'

module Esendex
  class SentMessageClient
    attr_accessor :api_connection

    def initialize(api_connection = ApiConnection.new)
      @api_connection = api_connection
    end

    def get_messages(criteria)
      request_uri = generate_uri criteria
      response = api_connection.get request_uri
      root = Nokogiri::XML.parse(response.body).root()
      messages = root.css('messageheader').map do |header|
        parse_header header
      end
      SentMessagesResult.new root['startindex'].to_i, root['totalcount'].to_i, messages
    end

    def parse_header(header)
      SentMessage.new({ 
        id: header['id'],
        account: header.at('reference').text,
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

    def format_contact(contact_node)
      number = contact_node.at('phonenumber').text
      if contact_node.at('displayname').nil? then 
        number
      else 
        "#{contact_node.at('displayname').text} <#{number}>"
      end
    end

    def generate_uri(criteria)
      uri = URI.parse("/v1.0/messageheaders?")
      separator = ''
      %w(account_reference start_index count start finish).each do |key|
        next unless criteria.key?(key.to_sym)
        uri.query += "#{separator}#{key.delete('_')}=#{URI.escape(criteria[key.to_sym].to_s)}"
        separator = '&'
      end
      uri.to_s
    end

    private :parse_header, :format_contact, :generate_uri
  end
end

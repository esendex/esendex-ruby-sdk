require 'nokogiri'

# <InboundMessage>
#  <Id>{guid-of-push-notification}</Id>
#  <MessageId>{guid-of-inbound-message}</MessageId>
#  <AccountId>{guid-of-esendex-account-for-message}</AccountId>
#  <MessageText>{Message text of inbound message}</MessageText>
#  <From>{phone number of sender of the message}</From>
#  <To>{phone number for the Virtual Mobile Number of your Account}</To>
# </InboundMessage>

module Esendex
  class InboundMessage
    include HashSerialisation

    attr_accessor :id, :message_id, :account_id, :message_text, :from, :to

    def self.from_xml(source)
      doc = Nokogiri::XML source
      event = InboundMessage.new
      event.id = doc.at_xpath("/InboundMessage/Id").content
      event.message_id = doc.at_xpath("/InboundMessage/MessageId").content
      event.account_id = doc.at_xpath("/InboundMessage/AccountId").content
      event.message_text = doc.at_xpath("/InboundMessage/MessageText").content
      event.from = doc.at_xpath("/InboundMessage/From").content
      event.to = doc.at_xpath("/InboundMessage/To").content
      event
    end
  end
end

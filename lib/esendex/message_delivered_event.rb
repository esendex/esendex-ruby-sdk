require 'nokogiri'

# <MessageDelivered>
#  <Id>{guid-of-push-notification}</Id>
#  <MessageId>{guid-of-inbound-message}</MessageId>
#  <AccountId>{guid-of-esendex-account-for-message}</AccountId>
#  <OccurredAt>
#   {the UTC DateTime (yyyy-MM-ddThh:mm:ss) the message was delivered}
#  </OccurredAt>
# </MessageDelivered>

module Esendex
  class MessageDeliveredEvent
    include HashSerialisation

    attr_accessor :id, :message_id, :account_id, :occurred_at

    def self.from_xml(source)
      doc = Nokogiri::XML source
      event = MessageDeliveredEvent.new
      event.id = doc.at_xpath("/MessageDelivered/Id").content
      event.message_id = doc.at_xpath("/MessageDelivered/MessageId").content
      event.account_id = doc.at_xpath("/MessageDelivered/AccountId").content
      occurred_at_s = doc.at_xpath("/MessageDelivered/OccurredAt").content
      event.occurred_at = DateTime.strptime(occurred_at_s, "%Y-%m-%dT%H:%M:%S").to_time
      event
    end
  end
end

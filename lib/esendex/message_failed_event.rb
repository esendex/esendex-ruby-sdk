require 'nokogiri'

# <MessageFailed>
#  <Id>{guid-of-push-notification}</Id>
#  <MessageId>{guid-of-inbound-message}</MessageId>
#  <AccountId>{guid-of-esendex-account-for-message}</AccountId>
#  <OccurredAt>
#   {the UTC DateTime (yyyy-MM-ddThh:mm:ss) the message failed}
#  </OccurredAt>
# </MessageDelivered>

module Esendex
  class MessageFailedEvent
    include HashSerialisation

    attr_accessor :id, :message_id, :account_id, :occurred_at

    def self.from_xml(source)
      doc = Nokogiri::XML source
      event = MessageFailedEvent.new
      event.id = doc.at_xpath("/MessageFailed/Id").content
      event.message_id = doc.at_xpath("/MessageFailed/MessageId").content
      event.account_id = doc.at_xpath("/MessageFailed/AccountId").content
      occurred_at_s = doc.at_xpath("/MessageFailed/OccurredAt").content
      event.occurred_at = DateTime.strptime(occurred_at_s, "%Y-%m-%dT%H:%M:%S").to_time
      event
    end
  end
end

require 'spec_helper'

describe MessageDeliveredEvent do
  describe ".from_xml" do
    let(:id) { random_string }
    let(:message_id) { random_string }
    let(:account_id) { random_string }
    let(:occurred_at) { random_time.utc }
    let(:source) {
      "<MessageDelivered>
         <Id>#{id}</Id>
         <MessageId>#{message_id}</MessageId>
         <AccountId>#{account_id}</AccountId>
         <OccurredAt>#{occurred_at.strftime("%Y-%m-%dT%H:%M:%S")}</OccurredAt>
        </MessageDelivered>"
    }

    subject { MessageDeliveredEvent.from_xml source }

    it "should set the id" do
      expect(subject.id).to eq(id)
    end
    it "should set the message_id" do
      expect(subject.message_id).to eq(message_id)
    end
    it "should set the account_id" do
      expect(subject.account_id).to eq(account_id)
    end
    it "should set the occurred_at" do
      expect(subject.occurred_at.to_i).to eq(occurred_at.to_i)
    end
  end
end
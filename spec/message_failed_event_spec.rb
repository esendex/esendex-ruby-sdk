require 'spec_helper'

describe MessageFailedEvent do
  describe "#from_xml" do
    let(:id) { random_string }
    let(:message_id) { random_string }
    let(:account_id) { random_string }
    let(:occurred_at) { random_time.utc }
    let(:source) {
      "<MessageFailed>
         <Id>#{id}</Id>
         <MessageId>#{message_id}</MessageId>
         <AccountId>#{account_id}</AccountId>
         <OccurredAt>#{occurred_at.strftime("%Y-%m-%dT%H:%M:%S")}</OccurredAt>
        </MessageFailed>"
    }

    subject { MessageFailedEvent.from_xml source }

    it "should set the id" do
      subject.id.should eq(id)
    end
    it "should set the message_id" do
      subject.message_id.should eq(message_id)
    end
    it "should set the account_id" do
      subject.account_id.should eq(account_id)
    end
    it "should set the occurred_at" do
      subject.occurred_at.to_i.should eq(occurred_at.to_i)
    end
  end
end
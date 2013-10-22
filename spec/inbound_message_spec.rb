require 'spec_helper'

describe InboundMessage do
  describe ".from_xml" do
    let(:id) { random_string }
    let(:message_id) { random_string }
    let(:account_id) { random_string }
    let(:message_text) { random_string }
    let(:from) { random_mobile }
    let(:to) { random_mobile }
    let(:source) {
      "<InboundMessage>
         <Id>#{id}</Id>
         <MessageId>#{message_id}</MessageId>
         <AccountId>#{account_id}</AccountId>
         <MessageText>#{message_text}</MessageText>
         <From>#{from}</From>
         <To>#{to}</To>
       </InboundMessage>"
    }

    subject { InboundMessage.from_xml source }

    it "should set the id" do
      subject.id.should eq(id)
    end
    it "should set the message_id" do
      subject.message_id.should eq(message_id)
    end
    it "should set the account_id" do
      subject.account_id.should eq(account_id)
    end
    it "should set the message_text" do
      subject.message_text.should eq(message_text)
    end
    it "should set the from" do
      subject.from.should eq(from)
    end
    it "should set the to" do
      subject.to.should eq(to)
    end
  end
end
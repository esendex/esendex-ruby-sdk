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
      expect(subject.id).to eq id
    end
    it "should set the message_id" do
      expect(subject.message_id).to eq message_id
    end
    it "should set the account_id" do
      expect(subject.account_id).to eq account_id
    end
    it "should set the message_text" do
      expect(subject.message_text).to eq message_text
    end
    it "should set the from" do
      expect(subject.from).to eq from
    end
    it "should set the to" do
      expect(subject.to).to eq to
    end
  end
end

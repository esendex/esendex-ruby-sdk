require 'spec_helper'

describe MessageBatchSubmission do
  let(:account) { "EX1234556" }

  describe "#xml_node" do
    let(:message_one) { Message.new("0777111222", "I'm sending this in the future") }
    let(:message_two) { Message.new("0777111333", "I'm sending this in the future again") }
    let(:message_batch) { MessageBatchSubmission.new(account, [message_one, message_two]) }

    subject { message_batch.xml_node }

    it "should create two message nodes" do
      subject.xpath('//messages/message').count.should eq(2)
    end
    context "when send_at set" do
      let(:target_time) { Time.local(2011, 4, 7, 15, 0, 0) }
  
      before(:each) do
        message_batch.send_at = target_time
      end

      it "should create a properly formatted sendat node" do
        subject.at_xpath('//messages/sendat').content.should eq("2011-04-07T15:00:00")
      end
    end
  end
end
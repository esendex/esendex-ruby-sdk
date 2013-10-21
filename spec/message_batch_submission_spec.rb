require 'spec_helper'

describe MessageBatchSubmission do
  let(:account) { "EX1234556" }

  describe "#xml_node" do
    let(:messages) { [ Message.new(random_mobile, random_string), Message.new(random_mobile, random_string)] }
    let(:message_batch) { MessageBatchSubmission.new(account, messages) }

    subject { message_batch.xml_node }

    it "should create message nodes" do
      subject.xpath('//messages/message').count.should eq(messages.count)
    end
    it "should set the message to" do
      (0..1).each do |i|
        subject.xpath('//messages/message/to')[i].content.should eq(messages[i].to)
      end
    end
    it "should set the message body" do
      (0..1).each do |i|
        subject.xpath('//messages/message/body')[i].content.should eq(messages[i].body)
      end
    end
    context "when #send_at set" do
      let(:target_time) { Time.local(2011, 4, 7, 15, 0, 0) }
  
      before(:each) do
        message_batch.send_at = target_time
      end

      it "should create a properly formatted sendat node" do
        subject.at_xpath('//messages/sendat').content.should eq("2011-04-07T15:00:00")
      end
    end
  end

  describe "#initialize with nil account reference" do
    it "should raise AccountReferenceError" do
      messages = [Message.new(random_mobile, random_string)]
      expect { MessageBatchSubmission.new nil, messages }.to raise_error(AccountReferenceError)
    end
  end

  describe "#initialize with empty message array" do
    it "should raise expected error" do
      expect { MessageBatchSubmission.new account, [] }.to raise_error("Need at least one message")
    end
  end
end
require 'spec_helper'

describe Account do
  let(:account_reference) { random_string }
  let(:account) { Account.new(account_reference) }
  let(:messages_remaining) { random_integer }
  let(:account_xml) {
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <accounts xmlns=\"http://api.esendex.com/ns/\">
        <account id=\"2b4a326c-41de-4a57-a577-c7d742dc145c\" uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c\">
          <balanceremaining domesticmessages=\"100\" internationalmessages=\"100\">$0.00</balanceremaining>
          <reference>not this one</reference>
          <address>447786204254</address>
          <type>Professional</type>
          <messagesremaining>1234</messagesremaining>
          <expireson>2015-12-31T00:00:00</expireson>
          <role>PowerUser</role>
          <defaultdialcode>44</defaultdialcode>
          <settings uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c/settings\" />
        </account>
        <account id=\"2b4a326c-41de-4a57-a577-c7d742dc145c\" uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c\">
          <balanceremaining domesticmessages=\"100\" internationalmessages=\"100\">$0.00</balanceremaining>
          <reference>#{account_reference}</reference>
          <address>447786204254</address>
          <type>Professional</type>
          <messagesremaining>#{messages_remaining}</messagesremaining>
          <expireson>2015-12-31T00:00:00</expireson>
          <role>PowerUser</role>
          <defaultdialcode>44</defaultdialcode>
          <settings uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c/settings\" />
        </account>
      </accounts>"
  }
  let(:api_connection) { mock("Connection", :get => mock('Response', :body => account_xml), :post => true )}

  before(:each) do
    account.stub(:api_connection) { api_connection }
  end

  describe "#messages_remaining" do
    subject { account.messages_remaining }

    it "should get the account resource" do
      api_connection.should_receive(:get).with("/v1.0/accounts")
      subject
    end
    
    it "should get the messages remaining from the document" do
      subject.should eq(messages_remaining)
    end
    
    context "with invalid reference" do
      before(:each) do
        account.reference = "invalid"
      end
    
      it "should raise AccountReferenceError" do
        expect { account.messages_remaining }.to raise_error(AccountReferenceError)
      end
    end 
  end

  describe "#send_message" do
    let(:batch_id) { random_string }
    let(:send_response_xml) {
      "<?xml version=\"1.0\" encoding=\"utf-8\"?> 
      <messageheaders batchid=\"#{batch_id}\" xmlns=\"http://api.esendex.com/ns/\">
        <messageheader\ uri=\"http://api.esendex.com/v1.0/MessageHeaders/00000000-0000-0000-0000-000000000001\" id=\"00000000-0000-0000-0000-000000000001\" />
      </messageheaders>"
    }

    before(:each) do
      api_connection.stub(:post) { mock('Response', :body => send_response_xml) }
    end

    subject { account.send_message(to: "447815777555", body: "Hello from the Esendex Ruby Gem") }

    it "should post to the message dispatcher resource" do
      api_connection.should_receive(:post).with("/v1.0/messagedispatcher", anything)
      subject
    end
    
    it "should return the batch_id when treated as string" do
      subject.to_s.should eq(batch_id)
    end
    
    it "should return the batch_id in the result" do
      subject.batch_id.should eq(batch_id)
    end
    
    it "should provide a list of messages with a single message" do
      subject.messages.should have(1).items
    end
  end

  describe "#send_messages" do
    let(:batch_id) { random_string }
    let(:uri_prefix) { "https://api.esendex.com/messages/" }
    let(:message_one_id) { random_guid }
    let(:message_two_id) { random_guid }
    let(:send_response_xml) {
      "<?xml version=\"1.0\" encoding=\"utf-8\"?> 
      <messageheaders batchid=\"#{batch_id}\" xmlns=\"http://api.esendex.com/ns/\">
        <messageheader\ uri=\"#{uri_prefix}#{message_one_id}\" id=\"#{message_one_id}\" />
        <messageheader\ uri=\"#{uri_prefix}#{message_two_id}\" id=\"#{message_two_id}\" />
      </messageheaders>"
    }

    before(:each) do
      api_connection.stub(:post) { mock('Response', :body => send_response_xml) }
    end

    subject { account.send_message(to: "447815777555", body: "Hello from the Esendex Ruby Gem") }

    it "should post to the message dispatcher resource" do
      api_connection.should_receive(:post).with("/v1.0/messagedispatcher", anything)
      subject
    end
    it "should provide a list containing two messages" do
      subject.messages.should have(2).items
    end
    it "should have message one in the message list" do
      subject.messages.should include(id: "#{message_one_id}", uri: "#{uri_prefix}#{message_one_id}")
    end
    it "should have message two in the message list" do
      subject.messages.should include(id: "#{message_two_id}", uri: "#{uri_prefix}#{message_two_id}")
    end
  end

  describe "#sent_messages" do
    let(:sent_message_client) { stub("sent_message_client") }
    let(:sent_messages_result) { Class.new }

    before(:each) do
      stub_const("Esendex::SentMessageClient", sent_message_client)
      sent_message_client
        .should_receive(:new)
        .with(api_connection)
        .and_return(sent_message_client)
    end

    describe "default (no args)" do
      before(:each) do
        sent_message_client
          .should_receive(:get_messages)
          .with({account_reference: account_reference})
          .and_return(sent_messages_result)
      end

      subject { account.sent_messages() }

      it "should return expected result" do
        subject.should eq(sent_messages_result)
      end
    end

    describe "with start and finish dates" do
      it "should pass dates without adjustment" do
        start_date = DateTime.now - 30
        finish_date = DateTime.now - 15
        sent_message_client
          .should_receive(:get_messages)
          .with({account_reference: account_reference, start: start_date, finish: finish_date})
          .and_return(sent_messages_result)

        account.sent_messages({start: start_date, finish: finish_date}).should_not be_nil
      end
    end

    describe "with start date" do
      it "should specify start date and default finish date" do
        start_date = DateTime.now - 1
        sent_message_client
          .should_receive(:get_messages)
          .with({account_reference: account_reference, start: start_date})
          .and_return(sent_messages_result)

        account.sent_messages({start: start_date}).should_not be_nil
      end
    end

    describe "with finish date" do
      it "should specify default start date and finish date" do
        finish_date = DateTime.now - 1
        start_date = finish_date - 90
        sent_message_client
          .should_receive(:get_messages)
          .with({account_reference: account_reference, finish: finish_date})
          .and_return(sent_messages_result)

        account.sent_messages({finish: finish_date}).should_not be_nil
      end
    end

    describe "with start index and count" do
      it "should pass expected arguments" do
        start_index = 3
        count = 35
        sent_message_client
          .should_receive(:get_messages)
          .with({account_reference: account_reference, start_index: start_index, count: count})
          .and_return(sent_messages_result)

        account.sent_messages({start_index: start_index, count: count}).should_not be_nil
      end
    end
  end
end

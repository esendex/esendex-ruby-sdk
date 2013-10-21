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
  end
  
  describe "#messages_remaining invalid reference" do
    before(:each) do
      account.reference = "invalid"
    end
  
    it "should raise AccountReferenceError" do
      expect { account.messages_remaining }.to raise_error(AccountReferenceError)
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
    let(:query_response_xml) {
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <messageheaders startindex=\"0\" count=\"1\" totalcount=\"99\" xmlns=\"http://api.esendex.com/ns/\">
        <messageheader id=\"00000000-0000-0000-0000-000000000001\" uri=\"https://api.esendex.com/v1.0/messageheaders/00000000-0000-0000-0000-000000000001\">
          <reference>EX9999999</reference>
          <status>Delivered</status>
          <deliveredat>2013-01-01T12:00:02Z</deliveredat>
          <sentat>2013-01-01T12:00:01Z</sentat>
          <laststatusat>2013-01-01T12:00:02Z</laststatusat>
          <submittedat>2013-01-01T12:00:00Z</submittedat>
          <type>SMS</type>
          <to>
            <phonenumber>447712345678</phonenumber>
          </to>
          <from>
            <phonenumber>testing123</phonenumber>
          </from>
          <summary>testestestestestestestestestestestestestestest...</summary>
          <body id=\"00000000-0000-0000-0000-000000000001\" uri=\"https://api.esendex.com/v1.0/messageheaders/00000000-0000-0000-0000-000000000001/body\" />
          <direction>Outbound</direction>
          <parts>2</parts>
          <username>user@example.com</username>
        </messageheader>
      </messageheaders>"
    }

    before(:each) do
      api_connection.stub(:get) { mock('Response', :body => query_response_xml) }
    end

    subject { account.sent_messages() }

    it "should get the message headers resource for the account reference" do
      api_connection.should_receive(:get).with("/v1.0/messageheaders?accountreference=#{account_reference}")
      subject
    end
    it "should return expected result type" do
      subject.should be_an_instance_of(SentMessagesResult)
    end
  end
end

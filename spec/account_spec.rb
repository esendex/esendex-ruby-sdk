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
  let(:api_connection) { double("Connection", get: double('Response', body: account_xml), post: true )}

  before(:each) do
    allow(account).to receive(:api_connection).and_return(api_connection)
  end

  describe "#messages_remaining" do
    subject { account.messages_remaining }

    it "should get the account resource" do
      expect(api_connection).to receive(:get).with '/v1.0/accounts'
      subject
    end

    it "should get the messages remaining from the document" do
      expect(subject).to eq messages_remaining
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
      allow(api_connection).to receive(:post).and_return( double('Response', body: send_response_xml) )
    end

    subject { account.send_message(to: "447815777555", body: "Hello from the Esendex Ruby Gem") }

    it "should post to the message dispatcher resource" do
      expect(api_connection).to receive(:post).with("/v1.0/messagedispatcher", anything)
      subject
    end

    it "should return the batch_id when treated as string" do
      expect(subject.to_s).to eq batch_id
    end

    it "should return the batch_id in the result" do
      expect(subject.batch_id).to eq batch_id
    end

    it "should provide a list of messages with a single message" do
      expect(subject.messages.count).to be 1
    end
  end

  describe "#send_messages" do
    let(:batch_id) { random_string }
    let(:uri_prefix) { 'https://api.esendex.com/messages/' }
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
      allow(api_connection).to receive(:post).and_return( double('Response', body: send_response_xml) )
    end

    subject { account.send_message(to: "447815777555", body: "Hello from the Esendex Ruby Gem") }

    it "should post to the message dispatcher resource" do
      expect(api_connection).to receive(:post).with("/v1.0/messagedispatcher", anything)
      subject
    end

    it "should provide a list containing two messages" do
      expect(subject.messages.count).to be 2
    end

    it "should have message one in the message list" do
      expect(subject.messages).to include(id: "#{message_one_id}", uri: "#{uri_prefix}#{message_one_id}")
    end

    it "should have message two in the message list" do
      expect(subject.messages).to include(id: "#{message_two_id}", uri: "#{uri_prefix}#{message_two_id}")
    end
  end

  describe "#message_status" do
    let(:uri_prefix) { "https://api.esendex.com/v1.0/messageheaders/" }
    let(:message_id) { random_guid }
    let(:phonenumber) { "12345678" }
    let(:status) { "Acknowledged" }
    let(:send_response_xml) {
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <messageheader id=\"#{message_id}\" xmlns=\"http://api.esendex.com/ns/\" uri=\"#{uri_prefix}#{message_id}\">
        <status>#{status}</status>
        <to>
          <phonenumber>#{phonenumber}</phonenumber>
        </to>
      </messageheader>"
    }

    before(:each) do
      allow(api_connection).to receive(:get).and_return( double('Response', body: send_response_xml) )
    end

    subject { account.message_status(message_id) }

    it "should post to the message dispatcher resource" do
      expect(api_connection).to receive(:get).with "/v1.0/messageheaders/#{message_id}"
      subject
    end

    it "should return the status in the result" do
      expect(subject.status).to eq status
    end

    it "should return phone number of recipient" do
      expect(subject.phonenumber).to eq phonenumber
    end
  end

  describe "#sent_messages" do
    let(:sent_message_client) { double("sent_message_client") }
    let(:sent_messages_result) { Class.new }

    before(:each) do
      stub_const("Esendex::SentMessageClient", sent_message_client)
      expect(sent_message_client).to receive(:new)
        .with(api_connection)
        .and_return(sent_message_client)
    end

    context "with no args" do
      before(:each) do
        expect(sent_message_client).to receive(:get_messages)
          .with({account_reference: account_reference})
          .and_return(sent_messages_result)
      end

      subject { account.sent_messages() }

      it "should return expected result" do
        expect(subject).to eq sent_messages_result
      end
    end

    context "with start and finish dates" do
      it "should pass dates without adjustment" do
        start_date = DateTime.now - 30
        finish_date = DateTime.now - 15
        expect(sent_message_client).to receive(:get_messages)
          .with({account_reference: account_reference, start: start_date, finish: finish_date})
          .and_return(sent_messages_result)

        expect(account.sent_messages({start: start_date, finish: finish_date})).not_to be_nil
      end
    end

    context "with start date" do
      it "should specify start date and default finish date" do
        start_date = DateTime.now - 1
        expect(sent_message_client).to receive(:get_messages)
          .with({account_reference: account_reference, start: start_date})
          .and_return(sent_messages_result)

        expect(account.sent_messages({start: start_date})).not_to be_nil
      end
    end

    context "with finish date" do
      it "should specify default start date and finish date" do
        finish_date = DateTime.now - 1
        start_date = finish_date - 90
        expect(sent_message_client).to receive(:get_messages)
          .with({account_reference: account_reference, finish: finish_date})
          .and_return(sent_messages_result)

        expect(account.sent_messages({finish: finish_date})).not_to be_nil
      end
    end

    context "with start index and count" do
      it "should pass expected arguments" do
        start_index = 3
        count = 35
        expect(sent_message_client).to receive(:get_messages)
          .with({account_reference: account_reference, start_index: start_index, count: count})
          .and_return(sent_messages_result)

        expect(account.sent_messages({start_index: start_index, count: count})).not_to be_nil
      end
    end
  end
end

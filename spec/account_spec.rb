require 'spec_helper'

describe Account do
  let(:user) { "codechallenge@esendex.com" }
  let(:password) { "c0d3cha113ng3" }
  let(:account_reference) { "EX0068832" }
  let(:messages_remaining) { 100 }
  let(:account_xml) {
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <accounts xmlns=\"http://api.esendex.com/ns/\">
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
  let(:connection) { mock("Connection", 
    :user= => true, :password= => true, :auth_type= => true, 
    :get => mock('Response', :body => account_xml), :post => true )}

  describe "#initialize" do
    
    subject { Account.new(account_reference, user, password, connection) }

    it "it sets the user on the connection" do
      connection.should_receive(:user=).with(user)
      subject
    end
    it "it sets the passwrd on the connection" do
      connection.should_receive(:password=).with(password)
      subject
    end
    it "it sets auth type to basic" do
      connection.should_receive(:auth_type=).with(:basic)
      subject
    end
    it "should get the account resource" do
      connection.should_receive(:get).with("/v0.1/accounts/#{account_reference}")
      subject
    end
    it "should set the messages remaining" do
      subject.messages_remaining.should eq(messages_remaining)
    end
  
    context "when 403 raised" do
      before(:each) do
        connection.stub(:get) { raise Nestful::ForbiddenAccess.new(nil) }
      end
      it "raises an Esendex::ForbiddenError" do
        expect { subject }.to raise_error(Esendex::ForbiddenError)
      end
    end
  end

  describe "#send_message" do
    let(:batch_id) { "2b4a326c-41de-4a57-a577-c7d742dc145c" }
    let(:send_response_xml) {
      "<?xml version=\"1.0\" encoding=\"utf-8\"?> 
      <messageheaders batchid=\"#{batch_id}\" xmlns=\"http://api.esendex.com/ns/\">
        <messageheader\ uri=\"http://api.esendex.com/v1.0/MessageHeaders/00000000-0000-0000-0000-000000000000\" id=\"00000000-0000-0000-0000-000000000000\" />
      </messageheaders>"
    }
    let(:account) { Account.new(account_reference, user, password, connection) }
    before(:each) do
      connection.stub(:post) { mock('Response', :body => send_response_xml) }
    end

    subject { account.send_message(Message.new("447815777555", "Hello from the Esendex Ruby Gem")) }

    it "posts to the message dispatcher resource" do
      connection.should_receive(:post).with("/v1.0/messagedispatcher", anything)
      subject
    end
    it "should return the batch_id in the result" do
      subject.should eq(batch_id)
    end
  end  
end

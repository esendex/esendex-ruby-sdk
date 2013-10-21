require 'spec_helper'

describe SentMessageClient do
  describe "#get_messages" do
    let(:start_index) { 10 }
    let(:count) { 1 }
    let(:total_count) { 99 }
    let(:message_id) { random_guid }
    let(:account_reference) { "EX9999999" }
    let(:api_response_xml) {
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <messageheaders startindex=\"#{start_index}\" count=\"#{count}\" totalcount=\"#{total_count}\" xmlns=\"http://api.esendex.com/ns/\">
          <messageheader id=\"#{message_id}\" uri=\"https://api.esendex.com/v1.0/messageheaders/#{message_id}\">
            <reference>#{account_reference}</reference>
            <status>Delivered</status>
            <deliveredat>2013-01-01T12:00:02Z</deliveredat>
            <sentat>2013-01-01T12:00:01Z</sentat>
            <laststatusat>2013-01-01T12:00:02Z</laststatusat>
            <submittedat>2013-01-01T12:00:00Z</submittedat>
            <type>SMS</type>
            <to id=\"00000000-0000-0000-0001-000000000000\" uri=\"https://api.esendex.com/v1.0/contacts/00000000-0000-0000-0001-000000000000\">
              <displayname>That Guy</displayname>
              <phonenumber>447712345678</phonenumber>
            </to>
            <from>
              <phonenumber>testing123</phonenumber>
            </from>
            <summary>testestestestestestestest</summary>
            <body id=\"#{message_id}\" uri=\"https://api.esendex.com/v1.0/messageheaders/#{message_id}/body\" />
            <direction>Outbound</direction>
            <parts>2</parts>
            <username>user@example.com</username>
          </messageheader>
        </messageheaders>"
      }
    let(:api_connection) { mock("Connection", :get => mock('Response', :body => api_response_xml))}
    let(:client) { SentMessageClient.new api_connection }

    subject { client.get_messages(account_reference) }

    it "should return instance of SentMessagesResult" do
      subject.should be_an_instance_of(SentMessagesResult)
    end
    it "should have start_index property" do
      subject.start_index.should eq(start_index)
    end
    it "should have total_messages property" do
      subject.total_messages.should eq(total_count)
    end
    it "should have messages array" do
      subject.messages.should_not be_empty
    end

    describe "returned message content" do
      subject { client.get_messages(account_reference).messages[0] }

      it "should have expected id on first message" do
        subject.id.should eq(message_id) 
      end
      it "should have expected status on first message" do
        subject.status.should eq("Delivered") 
      end
      it "should have expected status_at on first message" do
        subject.status_at.should eq(DateTime.iso8601('2013-01-01T12:00:02Z')) 
      end
      it "should have expected submitted_by on first message" do
        subject.submitted_by.should eq("user@example.com") 
      end
      it "should have expected submitted_at on first message" do
        subject.submitted_at.should eq(DateTime.iso8601('2013-01-01T12:00:00Z')) 
      end
      it "should have expected sent_at on first message" do
        subject.sent_at.should eq(DateTime.iso8601('2013-01-01T12:00:01Z')) 
      end
      it "should have expected delivered_at on first message" do
        subject.delivered_at.should eq(DateTime.iso8601('2013-01-01T12:00:02Z')) 
      end
      it "should have expected from on first message" do
        subject.from.should eq("testing123") 
      end
      it "should have expected to on first message" do
        subject.to.should eq("That Guy <447712345678>") 
      end
      it "should have expected type on first message" do
        subject.type.should eq("SMS") 
      end
      it "should have expected sms_parts on first message" do
        subject.sms_parts.should eq(2) 
      end
      it "should have expected summary on first message" do
        subject.summary.should eq("testestestestestestestest")
      end
      it "should have expected body on first message" do
        subject.body.should eq("testestestestestestestest")
      end
    end
  end
end

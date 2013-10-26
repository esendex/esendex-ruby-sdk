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
            <summary>testestestestestestestestestestestestestesteste...</summary>
            <body id=\"#{message_id}\" uri=\"https://api.esendex.com/v1.0/messageheaders/#{message_id}/body\" />
            <direction>Outbound</direction>
            <parts>2</parts>
            <username>user@example.com</username>
          </messageheader>
        </messageheaders>"
      }
    let(:api_connection) { double('api_connection') }
    let(:client) { SentMessageClient.new api_connection }

    describe "with account reference" do
      before(:each) do
        api_connection.should_receive(:get).with("/v1.0/messageheaders?accountreference=#{CGI.escape(account_reference)}") do 
          stub('Response', :body => api_response_xml)
        end
      end

      subject { client.get_messages({account_reference: account_reference}) }

      it "should return instance of SentMessagesResult" do
        subject.should be_an_instance_of(SentMessagesResult)
      end
    end

    describe "with paging" do
      before(:each) do
        api_connection.should_receive(:get).with("/v1.0/messageheaders?startindex=#{start_index}&count=#{count}") do 
          stub('Response', :body => api_response_xml)
        end
      end

      subject { client.get_messages({
        start_index: start_index,
        count: count
        })
      }

      it "should return instance of SentMessagesResult" do
        subject.should be_an_instance_of(SentMessagesResult)
      end
    end

    describe "with date range" do
      let(:end_date) { DateTime.now - 30 }
      let(:start_date) { end_date - 365 }
      before(:each) do
        api_connection.should_receive(:get).with("/v1.0/messageheaders?start=#{CGI.escape(start_date.iso8601)}&finish=#{CGI.escape(end_date.iso8601)}") do 
          stub('Response', :body => api_response_xml)
        end
      end

      subject { client.get_messages({
        start: start_date,
        finish: end_date
        })
      }

      it "should return instance of SentMessagesResult" do
        subject.should be_an_instance_of(SentMessagesResult)
      end
    end

    describe "returned result content" do
      let(:message_body) { "remote message body" }
      before(:each) do
        api_connection
          .should_receive(:get)
          .with("/v1.0/messageheaders?accountreference=#{CGI.escape(account_reference)}&startindex=10&count=1")
          .and_return(stub('Headers', :body => api_response_xml))
      end

      subject { client.get_messages(account_reference: account_reference, start_index: 10, count: 1) }

      it "should have expected page" do
        subject.page.should eq(11)
      end
      it "should have expected total_messages" do
        subject.total_messages.should eq(99)
      end
      it "should return expected result for previous_page" do
        api_connection
          .should_receive(:get)
          .with("/v1.0/messageheaders?accountreference=#{CGI.escape(account_reference)}&startindex=9&count=1")
          .and_return(stub('PrevHeaders', :body => api_response_xml))

        subject.previous_page.should be_an_instance_of(SentMessagesResult)
      end
      it "should return expected result for next_page" do
        api_connection
          .should_receive(:get)
          .with("/v1.0/messageheaders?accountreference=#{CGI.escape(account_reference)}&startindex=11&count=1")
          .and_return(stub('NextHeaders', :body => api_response_xml))

        subject.next_page.should be_an_instance_of(SentMessagesResult)
      end
      it "should have expected id on first message" do
        subject.messages[0].id.should eq(message_id) 
      end
      it "should have expected account on first message" do
        subject.messages[0].account.should eq(account_reference)
      end
      it "should have expected status on first message" do
        subject.messages[0].status.should eq("Delivered") 
      end
      it "should have expected status_at on first message" do
        subject.messages[0].status_at.should eq(DateTime.iso8601('2013-01-01T12:00:02Z')) 
      end
      it "should have expected submitted_by on first message" do
        subject.messages[0].submitted_by.should eq("user@example.com") 
      end
      it "should have expected submitted_at on first message" do
        subject.messages[0].submitted_at.should eq(DateTime.iso8601('2013-01-01T12:00:00Z')) 
      end
      it "should have expected sent_at on first message" do
        subject.messages[0].sent_at.should eq(DateTime.iso8601('2013-01-01T12:00:01Z')) 
      end
      it "should have expected delivered_at on first message" do
        subject.messages[0].delivered_at.should eq(DateTime.iso8601('2013-01-01T12:00:02Z')) 
      end
      it "should have expected from on first message" do
        subject.messages[0].from.should eq("testing123") 
      end
      it "should have expected to on first message" do
        subject.messages[0].to.should eq("That Guy <447712345678>") 
      end
      it "should have expected type on first message" do
        subject.messages[0].type.should eq("SMS") 
      end
      it "should have expected sms_parts on first message" do
        subject.messages[0].sms_parts.should eq(2) 
      end
      it "should have expected summary on first message" do
        subject.messages[0].summary.should eq("testestestestestestestestestestestestestesteste...")
      end
      it "should have expected body on first message" do
        api_connection
          .should_receive(:get)
          .with("https://api.esendex.com/v1.0/messageheaders/#{message_id}/body")
          .and_return(stub('Body', :body => "<?xml version=\"1.0\" encoding=\"utf-8\"?><messagebody xmlns=\"http://api.esendex.com/ns/\"><bodytext>#{message_body}</bodytext></messagebody>"))

        subject.messages[0].body.should eq(message_body)
      end
    end
  end

  describe "#get_message" do
    let(:message_id) { random_guid }
    let(:account_reference) { "EX9999999" }
    let(:status) { "Submitted" }
    let(:submitted_at) { DateTime.now }
    let(:type) { "Voice" }
    let(:contact_id) { random_guid }
    let(:contact_name) { random_string }
    let(:contact_number) { random_mobile }
    let(:originator) { random_mobile }
    let(:summary) { random_string }
    let(:parts) { random_integer }
    let(:username) { random_email }
    let(:api_response_xml) {
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <messageheader id=\"#{message_id}\" uri=\"https://api.esendex.com/v1.0/messageheaders/#{message_id}\">
          <reference>#{account_reference}</reference>
          <status>#{status}</status>
          <laststatusat>#{submitted_at.iso8601}</laststatusat>
          <submittedat>#{submitted_at.iso8601}</submittedat>
          <type>#{type}</type>
          <to id=\"#{contact_id}\" uri=\"https://api.esendex.com/v1.0/contacts/#{contact_id}\">
            <displayname>#{contact_name}</displayname>
            <phonenumber>#{contact_number}</phonenumber>
          </to>
          <from>
            <phonenumber>#{originator}</phonenumber>
          </from>
          <summary>#{summary}</summary>
          <body id=\"#{message_id}\" uri=\"https://api.esendex.com/v1.0/messageheaders/#{message_id}/body\" />
          <direction>Outbound</direction>
          <parts>#{parts}</parts>
          <username>#{username}</username>
        </messageheader>"
      }
    let(:api_connection) { double('api_connection') }
    let(:client) { SentMessageClient.new api_connection }

    before(:each) do
      api_connection.should_receive(:get).with("/v1.0/messageheaders/#{message_id}") do 
        stub('Response', :body => api_response_xml)
      end
    end

    subject { client.get_message(message_id) }

    it "should have expected id on message" do
      subject.id.should eq(message_id) 
    end
    it "should have expected account on message" do
      subject.account.should eq(account_reference)
    end
    it "should have expected status on message" do
      subject.status.should eq(status) 
    end
    it "should have expected status_at on message" do
      subject.status_at.to_s.should eq(submitted_at.to_s) 
    end
    it "should have expected submitted_by on message" do
      subject.submitted_by.should eq(username) 
    end
    it "should have expected submitted_at on message" do
      subject.submitted_at.to_s.should eq(submitted_at.to_s) 
    end
    it "should have expected sent_at on message" do
      subject.sent_at.should be_nil
    end
    it "should have expected delivered_at on message" do
      subject.delivered_at.should be_nil 
    end
    it "should have expected from on message" do
      subject.from.should eq(originator) 
    end
    it "should have expected to on message" do
      subject.to.should eq("#{contact_name} <#{contact_number}>") 
    end
    it "should have expected type on message" do
      subject.type.should eq(type) 
    end
    it "should have expected sms_parts on message" do
      subject.sms_parts.should eq(parts) 
    end
    it "should have expected summary on message" do
      subject.summary.should eq(summary)
    end
  end
end

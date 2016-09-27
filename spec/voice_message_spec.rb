require 'spec_helper'

describe VoiceMessage do
  context 'a voice message' do
    let(:to) { random_mobile }
    let(:body) { random_string }
    let(:message) { Esendex::VoiceMessage.new(to, body) }

    subject { message.xml_node }

    context 'its xml' do
      it "contains to" do
        subject.at_xpath('//message/to').content.should eq(to)
      end

      it "contains body" do
        subject.at_xpath('//message/body').content.should eq(body)
      end

      it "contains type" do
        subject.at_xpath('//message/type').content.should eq('Voice')
      end

      it "contains language" do
        subject.at_xpath('//message/lang').content.should eq('en-GB')
      end
    end
  end
end

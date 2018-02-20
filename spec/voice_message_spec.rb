require 'spec_helper'

describe VoiceMessage do
  context 'a voice message' do
    let(:to) { random_mobile }
    let(:body) { random_string }
    let(:message) { Esendex::VoiceMessage.new(to, body) }

    subject { message.xml_node }

    context 'its xml' do
      it "contains to" do
        expect(subject.at_xpath('//message/to').content).to eq(to)
      end

      it "contains body" do
        expect(subject.at_xpath('//message/body').content).to eq(body)
      end

      it "contains type" do
        expect(subject.at_xpath('//message/type').content).to eq('Voice')
      end

      it "contains language" do
        expect(subject.at_xpath('//message/lang').content).to eq('en-GB')
      end
    end
  end
end

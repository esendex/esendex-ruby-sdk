require 'spec_helper'

describe Message do
  describe "#initialize" do
    let(:to) { random_mobile }
    let(:from) { random_mobile }
    let(:body) { random_string }
    let(:message) { Esendex::Message.new(to, body, from) }
    
    it "should have to set" do
      expect(message.to).to eq(to)
    end
    
    it "should have from set" do
      expect(message.from).to eq(from)
    end
    
    it "should have body set" do
      expect(message.body).to eq(body)
    end
  end
  
  describe "#xml_node" do
    let(:to) { random_mobile }
    let(:body) { random_string }
    let(:message) { Esendex::Message.new(to, body) }

    subject { message.xml_node }

    it "contains a to node" do
      expect(subject.at_xpath('//message/to').content).to eq(to)
    end
    it "contains a body node" do
      expect(subject.at_xpath('//message/body').content).to eq(body)
    end

    context "when #from set" do
      let(:from) { random_string }

      before(:each) do
        message.from = from
      end

      it "contains a from node" do
        expect(subject.at_xpath('//message/from').content).to eq(from)
      end
    end
  end
end

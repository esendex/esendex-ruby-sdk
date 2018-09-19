require 'spec_helper'

describe Message do
  describe "#initialize" do
    let(:to) { random_mobile }
    let(:from) { random_mobile }
    let(:body) { random_string }
    let(:characterset) { 'Unicode' }
    let(:message) { Esendex::Message.new(to, body, from, characterset) }
    
    it "should have to set" do
      expect(message.to).to eq(to)
    end
    
    it "should have from set" do
      expect(message.from).to eq(from)
    end
    
    it "should have body set" do
      expect(message.body).to eq(body)
    end

    it "should have characterset set" do
      expect(message.characterset).to eq(characterset)
    end
  end
  
  describe "#xml_node" do
    let(:to) { random_mobile }
    let(:body) { random_string }
    let(:characterset) { 'Auto' }
    let(:message) { Esendex::Message.new(to, body, ) }

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

    it "contains a characterset node" do
      expect(subject.at_xpath('//message/characterset').content).to eq(characterset)
    end
  end
end

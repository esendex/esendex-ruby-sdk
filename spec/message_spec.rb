require 'spec_helper'

describe Message do
  describe "#initialize" do
    let(:to) { random_mobile }
    let(:from) { random_mobile }
    let(:body) { random_string }
    let(:message) { Esendex::Message.new(to, body, from) }

    it "should have to set" do
      message.to.should eq(to)
    end

    it "should have from set" do
      message.from.should eq(from)
    end

    it "should have body set" do
      message.body.should eq(body)
    end

    context 'when #type set' do
      let(:type) { 'Voice' }
      let(:message) { Esendex::Message.new(to, body, from, type) }

      it "should have type set" do
        message.type.should eq(type)
      end

      it "should have default lang set" do
        message.lang.should eq('en-GB')
      end

      it "should have default retries count set" do
        message.retries.should eq('3')
      end
    end

    context 'when all voice message options set' do
      let(:type) { 'Voice' }
      let(:lang) { 'en-GB' }
      let(:retries) { random_integer }
      let(:message) { Esendex::Message.new(to, body, from, type, lang, retries) }

      it "should have type set" do
        message.type.should eq(type)
      end

      it "should have lang set" do
        message.lang.should eq(lang)
      end

      it "should have retries set" do
        message.retries.should eq(retries)
      end
    end
  end

  describe "#xml_node" do
    let(:to) { random_mobile }
    let(:body) { random_string }
    let(:message) { Esendex::Message.new(to, body) }

    subject { message.xml_node }

    it "contains a to node" do
      subject.at_xpath('//message/to').content.should eq(to)
    end
    it "contains a body node" do
      subject.at_xpath('//message/body').content.should eq(body)
    end

    it "contains a type node" do
      subject.at_xpath('//message/type').content.should eq('SMS')
    end
    
    context "when #from set" do
      let(:from) { random_string }

      before(:each) do
        message.from = from
      end

      it "contains a from node" do
        subject.at_xpath('//message/from').content.should eq(from)
      end
    end

    context 'when voice message options set' do
      let(:from) { random_string }
      let(:type) { 'Voice' }
      let(:lang) { 'en-GB' }
      let(:retries) { random_integer.to_s }
      let(:message) { Esendex::Message.new(to, body, from, type, lang, retries) }

      it "contains a type node" do
        subject.at_xpath('//message/type').content.should eq('Voice')
      end

      it "contains a lang node" do
        subject.at_xpath('//message/lang').content.should eq(lang)
      end

      it "contains a retries node" do
        subject.at_xpath('//message/retries').content.should eq(retries)
      end
    end
  end
end

require 'spec_helper'

describe Message do
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

    context "when from set" do
      let(:from) { random_string }

      before(:each) do
        message.from = from
      end

      it "contains a from node" do
        subject.at_xpath('//message/from').content.should eq(from)
      end
    end
  end
end
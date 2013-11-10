require 'spec_helper'

describe SentMessage do
  describe "#body" do
    let(:summary_body) { "Summary body text" }
    let(:remote_body) { "Remote body text" }
    let(:remote_calls) { 0 }
    let(:remote_stub) { double() }

    before(:each) do
      remote_stub.stub(:call) { remote_body }
    end

    describe "when summary has entire body text" do
      subject { SentMessage.new({ summary: summary_body }, remote_stub) }

      it "should return summary text" do
        subject.body.should eq(summary_body)
      end

      it "should not invoke remote lookup" do
        remote_calls.should eq(0)
      end
    end

    describe "when summary does not contain entire body text" do
      subject { SentMessage.new({ summary: 'X' * 50 }, remote_stub) }

      it "should return remote body text" do
        subject.body.should eq(remote_body)
      end

      it "should invoke the remote call once only" do
        remote_stub.should_receive(:call).at_most(:once)
        (0...10).each do
          result = subject.body
        end
      end
    end
  end
end


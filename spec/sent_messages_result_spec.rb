require 'spec_helper'

describe SentMessagesResult do
  describe "attributes" do
    let(:page) { 20 }
    let(:total_messages) { 133 }
    let(:messages) { Array.new(4) }

    subject { SentMessagesResult.new(page, total_messages, messages, lambda {}, lambda {}) }

    describe "#page" do
      it "should have page attribute" do
        subject.page.should eq(page)
      end
    end

    describe "#total_messages" do
      it "should have total_messages attribute" do
        subject.total_messages.should eq(total_messages)
      end
    end

    describe "#message" do
      it "should have messages attribute" do
        subject.messages.should eq(messages)
      end
    end

    describe "#total_pages" do
      it "should have total_pages attribute" do
        subject.total_pages.should eq(34)
      end
    end
  end

  describe "#first_page?" do
    it "should return true when first page" do
      SentMessagesResult
        .new(1, 20, Array.new(10))
        .first_page?.should be_true
    end

    it "should return false when not first page" do
      SentMessagesResult
        .new(2, 20, Array.new(10), lambda {})
        .first_page?.should be_false
    end
  end

  describe "#last_page?" do
    it "should return true when last page" do
      SentMessagesResult
        .new(2, 20, Array.new(10))
        .last_page?.should be_true
    end

    it "should return false when not last page" do
      SentMessagesResult
        .new(1, 20, Array.new(10), nil, lambda {})
        .last_page?.should be_false
    end
  end

  describe "#previous_page" do
    it "should return expected result" do
      previous_result = Class.new
      previous_page_func = lambda { previous_result }
      SentMessagesResult
        .new(2, 20, Array.new(10), previous_page_func)
        .previous_page
        .should eq(previous_result)
    end

    it "should raise error when first page" do
      result = SentMessagesResult.new(1, 20, Array.new(10))

      expect { result.previous_page }.to raise_error(StandardError, "previous page not available")
    end
  end

  describe "#next_page" do
    it "should return expected result" do
      next_result = Class.new
      next_page_func = lambda { next_result }
      SentMessagesResult
        .new(1, 20, Array.new(10), nil, next_page_func)
        .next_page
        .should eq(next_result)
    end

    it "should raise error when last page" do
      result = SentMessagesResult.new(2, 20, Array.new(10))

      expect { result.next_page }.to raise_error(StandardError, "next page not available")
    end
  end
end

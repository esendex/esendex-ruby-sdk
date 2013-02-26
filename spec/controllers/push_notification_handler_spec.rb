require 'spec_helper'

module Esendex
  class DummyPushNotificationController
    include PushNotificationHandler
  end

  describe PushNotificationHandler do
    let(:controller) { DummyPushNotificationController.new }
    before(:each) do
      @logger = mock('Logger', info: true)
      controller.stub(:logger) { @logger }
      controller.stub(:render)
    end

    subject { controller.process_notification @type, @source }

    context "when MessageEventDelivered" do
      let(:id) { random_string }
      let(:message_id) { random_string }
      let(:account_id) { random_string }
      let(:occurred_at) { random_time.utc } 

      before(:each) do
        @handler = lambda { |event| @received_id = event.id }
        @type = :message_delivered_event
        @source = "<MessageDelivered>
         <Id>#{id}</Id>
         <MessageId>#{message_id}</MessageId>
         <AccountId>#{account_id}</AccountId>
         <OccurredAt>#{occurred_at.strftime("%Y-%m-%dT%H:%M:%S")}</OccurredAt>
        </MessageDelivered>"
        @notification = MessageDeliveredEvent.from_xml(@source)
        MessageDeliveredEvent.stub(:from_xml) { @notification }
      end

      context "when a handler is configured" do
        before(:each) do
          Esendex.message_delivered_event_handler = @handler
        end
        it "initializes a MessageDeliveredEvent from the source" do
          MessageDeliveredEvent.should_receive(:from_xml).with(@source)
          subject
        end
        it "calls the handler" do
          @handler.should_receive(:call).with(@notification)
          subject
        end
        it "the handler can process the input" do
          subject
          @received_id.should eq(id)
        end
      end
      context "when no handler configured" do
        before(:each) do
          Esendex.message_delivered_event_handler = nil
        end
        it "does not init a MessageDeliveredEvent" do
          MessageDeliveredEvent.should_not_receive(:from_xml)
          subject
        end
        it "should log info line" do
          @logger.should_receive(:info).with(/#{@type.to_s}/)
          subject
        end
      end
    end
  end
end
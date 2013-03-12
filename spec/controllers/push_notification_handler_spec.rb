require 'spec_helper'

module Esendex
  class DummyPushNotificationController
    include PushNotificationHandler
  end

  describe PushNotificationHandler do
    let(:controller) { DummyPushNotificationController.new }

    subject { controller.process_notification @type, @source }

    before(:each) do
      @logger = mock('Logger', info: true)
      controller.stub(:logger) { @logger }
      controller.stub(:render)
    end

    @notifications = {
      :message_delivered_event => { 
        :class => MessageDeliveredEvent, 
        :source => "<MessageDelivered>
         <Id>#{random_string}</Id>
         <MessageId>#{random_string}</MessageId>
         <AccountId>#{random_string}</AccountId>
         <OccurredAt>#{random_time.strftime("%Y-%m-%dT%H:%M:%S")}</OccurredAt>
        </MessageDelivered>" 
      },
      :message_failed_event => {
        :class => MessageFailedEvent,
        :source => "<MessageFailed>
         <Id>#{random_string}</Id>
         <MessageId>#{random_string}</MessageId>
         <AccountId>#{random_string}</AccountId>
         <OccurredAt>#{random_time.strftime("%Y-%m-%dT%H:%M:%S")}</OccurredAt>
        </MessageFailed>" 
      },
      :inbound_message => {
        :class => InboundMessage,
        :source => "<InboundMessage>
         <Id>#{random_string}</Id>
         <MessageId>#{random_string}</MessageId>
         <AccountId>#{random_string}</AccountId>
         <MessageText>#{random_string}</MessageText>
         <From>#{random_mobile}</From>
         <To>#{random_mobile}</To>
        </InboundMessage>"
      }
    }
    @notifications.each_pair do |notification_type, config|
      context "when #{config[:class]}" do

        before(:each) do
          @type = notification_type
          @handler = lambda { |n| 
            @received_id = n.id 
          }
          @source = config[:source]
          @notification_class = config[:class]
          @notification = @notification_class.from_xml(@source)
          @notification_class.stub(:from_xml) { @notification }
        end

        context "when a handler is configured" do
          before(:each) do
            Esendex.send("#{notification_type}_handler=", @handler)
          end
          it "initializes a #{config[:class].name} from the source" do
            @notification_class.should_receive(:from_xml).with(@source)
            subject
          end
          it "calls the handler" do
            @handler.should_receive(:call).with(@notification)
            subject
          end
          it "the handler can process the input" do
            subject
            @received_id.should eq(@notification.id)
          end
        end
        context "when no handler configured" do
          before(:each) do
            Esendex.send("#{notification_type}_handler=", nil)
          end
          it "does not init a #{config[:class].name}" do
            @notification_class.should_not_receive(:from_xml)
            subject
          end
          it "should log info line" do
            @logger.should_receive(:info).with(/#{notification_type.to_s}/)
            subject
          end
        end
      end
    end
  end
end
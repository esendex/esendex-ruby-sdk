require 'spec_helper'

# Unable to run controller tests because of this issue https://github.com/rspec/rspec-rails/issues/469
module Esendex
  describe MessageDeliveredEventsController do
    describe "#create" do
      let(:id) { random_string }
      let(:message_id) { random_string }
      let(:account_id) { random_string }
      let(:occurred_at) { random_time.utc }
      let(:source) {
        "<MessageDelivered>
           <Id>#{id}</Id>
           <MessageId>#{message_id}</MessageId>
           <AccountId>#{account_id}</AccountId>
           <OccurredAt>#{occurred_at.strftime("%Y-%m-%dT%H:%M:%S")}</OccurredAt>
          </MessageDelivered>"
      }
      subject { 
        controller.request.env['RAW_POST_DATA'] = source
        post :create
      }

      # it "should be successful" do
      #   subject
      #   response.should eq(200)
      # end
    end
  end
end
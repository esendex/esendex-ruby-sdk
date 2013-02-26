require 'spec_helper'

module Esendex
  describe MessageDeliveredEventsController do
    describe "#create" do

      subject { post :create }

      it "should be successful" do
        subject
        response.should eq(200)
      end
    end
  end
end
module Esendex
  class MessageDeliveredEventsController < ApplicationController
    include PushNotificationHandler

    def create
      process_notification :message_delivered_event, request.body
      render text: ""
    end
  end
end
module Esendex
  class MessageDeliveredEventsController < ApplicationController
    include PushNotificationHandler

    def create
      process_notification :message_delivered_event, request.body
      render text: "OK"
    rescue => e
      render_error e
    end
  end
end

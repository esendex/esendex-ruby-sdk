module Esendex
  class MessageFailedEventsController < ApplicationController
    include PushNotificationHandler

    def create
      process_notification :message_failed_event, request.body
      render text: "OK"
    rescue => e
      render_error e
    end
  end
end

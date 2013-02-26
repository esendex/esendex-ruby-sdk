module Esendex
  class MessageFailedEventsController < ApplicationController
    include PushNotificationHandler

    def create
      process_notification :message_failed_event, request.body
      render text: ""
    end
  end
end
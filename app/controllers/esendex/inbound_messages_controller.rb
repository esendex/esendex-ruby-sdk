module Esendex
  class InboundMessagesController < ApplicationController
    include PushNotificationHandler

    def create
      process_notification :inbound_message, request.body
      render text: "OK"
    rescue => e
      render_error e
    end
  end
end

module Esendex
  class InboundMessagesController < ApplicationController
    include PushNotificationHandler

    def create
      process_notification :inbound_message, request.body
      render text: ""
    end
  end
end
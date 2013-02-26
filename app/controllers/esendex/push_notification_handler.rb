module Esendex
  module PushNotificationHandler

    def process_notification(type, source)
       
      if handler = Esendex.send("#{type}_handler")
        notification_class = Esendex.const_get(type.to_s.camelize)
        notification = notification_class.from_xml source
        handler.call notification
      else
        logger.info "Received #{type} push notification but no handler configured" if defined?(logger)
      end

   end
  end
end
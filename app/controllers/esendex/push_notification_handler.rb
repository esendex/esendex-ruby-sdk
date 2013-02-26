# Common behaviour for all push notification controllers
# 
module Esendex
  module PushNotificationHandler

    # Used by controllers to handle incoming push notification
    # 
    # type        - Symbol indicating type
    # source      - String request body of the notification
    # 
    # Returns nothing
    def process_notification(type, source)
       
      if handler = Esendex.send("#{type}_handler")
        notification_class = Esendex.const_get(type.to_s.camelize)
        notification = notification_class.from_xml source
        handler.call notification
      else
        logger.info "Received #{type} push notification but no handler configured" if defined?(logger)
      end

    end

    def render_error(error)
      lines = []
      lines << "Path: #{request.path}"
      request.body.rewind
      lines << "Body:\r\n#{request.body.read}"
      lines << "Error: #{error.class.name}"
      lines << "Message: #{error.message}"
      if Esendex.suppress_back_trace
        lines << "[backtrace suppressed]"
      else
        lines << error.backtrace.join("\r\n")
      end
      render text: lines.join("\r\n"), status: 500
    end
  end
end
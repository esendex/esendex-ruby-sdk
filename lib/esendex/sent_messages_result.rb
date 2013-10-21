module Esendex
  class SentMessagesResult
    attr_reader :start_index, :total_messages, :messages

    def initialize(start_index, total_messages, messages)
      @start_index, @total_messages, @messages = start_index, total_messages, messages
    end
  end
end

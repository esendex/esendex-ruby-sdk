module Esendex
  class SentMessagesResult    
    attr_reader :page, :total_pages, :total_messages, :messages
    @previous_page_func
    @next_page_func
    @page_size
    @last_message
    @first_message

    def initialize(page, total_messages, messages, previous_page_func = nil, next_page_func = nil)
      @page, @total_messages, @messages = page, total_messages, messages
      @previous_page_func, @next_page_func = previous_page_func, next_page_func
      @total_pages = last_page? ? @page : (@total_messages.to_f / @messages.length).ceil
      @page_size = @messages.length
      @last_message = last_page? ? @total_messages : @page * @page_size
      @first_message = (@last_message - @page_size) + 1
    end

    def first_page?
      @previous_page_func.nil?
    end

    def last_page?
      @next_page_func.nil?
    end

    def previous_page
      raise StandardError, "previous page not available" if @previous_page_func.nil?

      @previous_page_func.call
    end

    def next_page
      raise StandardError, "next page not available" if @next_page_func.nil?

      @next_page_func.call
    end

    def to_s
      "#{@first_message} to #{@last_message} (#{@page_size} messages) of #{@total_messages}, page #{@page} of #{@total_pages}"
    end
  end
end

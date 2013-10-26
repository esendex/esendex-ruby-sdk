module Esendex
  class SentMessagesResult    
    attr_reader :page, :total_pages, :total_messages, :messages
    @previous_page_func
    @next_page_func

    def initialize(page, total_messages, messages, previous_page_func = nil, next_page_func = nil)
      @page, @total_messages, @messages = page, total_messages, messages
      @previous_page_func, @next_page_func = previous_page_func, next_page_func
      @total_pages = last_page? ? @page : (@total_messages.to_f / @messages.length).ceil
    end

    def first_page?
      @previous_page_func.nil?
    end

    def last_page?
      @next_page_func.nil?
    end

    def previous_page
      raise StandardError, "previous page not available" if @previous_page_func.nil?

      @previous_page_func[]
    end

    def next_page
      raise StandardError, "next page not available" if @next_page_func.nil?

      @next_page_func[]
    end

    def to_s
      "#{@messages.length} messages of #{@total_messages} (page #{@page} of #{@total_pages})"
    end
  end
end

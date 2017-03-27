require 'nokogiri'

module Esendex
  class MessageStatus
    attr_reader :status, :phonenumber

    def initialize(status, phonenumber)
      @status = status
      @phonenumber = phonenumber
    end

    def self.from_xml(source)
      doc = Nokogiri::XML source
      status = doc.at_css("status").children.text
      phonenumber = doc.at_css("phonenumber").children.text
      MessageStatus.new status, phonenumber
    end

    def to_s
      status
    end
  end
end

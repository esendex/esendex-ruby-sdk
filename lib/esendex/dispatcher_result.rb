require 'nokogiri'

module Esendex
  class DispatcherResult
    attr_reader :batch_id, :messages

    def initialize(batch_id, messages)
      @batch_id = batch_id
      @messages = messages
    end

    def self.from_xml(source)
      doc = Nokogiri::XML source
      batch_id = doc.at_xpath('//api:messageheaders', 'api' => Esendex::API_NAMESPACE)['batchid']
      messages = doc.xpath('//api:messageheader', 'api' => Esendex::API_NAMESPACE).map do |header|
        { id: header['id'], uri: header['uri'] }
      end
      DispatcherResult.new batch_id, messages
    end

    def to_s
      self.batch_id
    end
  end
end

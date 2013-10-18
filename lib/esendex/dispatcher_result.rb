require 'nokogiri'

module Esendex
	class DispatcherResult
		attr_accessor :batch_id, :messages

		def self.from_xml(source)
			doc = Nokogiri::XML source
			result = DispatcherResult.new
			result.batch_id = doc.at_xpath('//api:messageheaders', 'api' => Esendex::API_NAMESPACE)['batchid']
      result.messages = Array.new
      doc.xpath('//api:messageheader', 'api' => Esendex::API_NAMESPACE).each do |header|
        result.messages << { :id => header['id'], :uri => header['uri'] }
      end
      result
		end

		def to_s
			self.batch_id
		end
	end
end

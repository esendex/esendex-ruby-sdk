module Esendex
  class VoiceMessage
    attr_accessor :to, :body, :from

    def initialize(to, body, from = nil)
      @to = to
      @body = body
      @from = from
    end

    def xml_node
      doc = Message.new(to, body, from).xml_node

      lang = Nokogiri::XML::Node.new 'lang', doc
      lang.content = 'en-GB'
      doc.add_child(lang)

      type = Nokogiri::XML::Node.new 'type', doc
      type.content = 'Voice'
      doc.add_child(type)

      doc
    end
  end
end

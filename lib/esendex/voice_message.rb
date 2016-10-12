module Esendex
  class VoiceMessage
    attr_accessor :to, :body, :from, :retries

    def initialize(to, body, from = nil, options = {})
      @to = to
      @body = body
      @from = from
      @retries = options[:retries]
    end

    def xml_node
      doc = Message.new(to, body, from).xml_node

      lang = Nokogiri::XML::Node.new 'lang', doc
      lang.content = 'en-GB'
      doc.add_child(lang)

      type = Nokogiri::XML::Node.new 'type', doc
      type.content = 'Voice'
      doc.add_child(type)

      if @retries
        retries = Nokogiri::XML::Node.new 'retries', doc
        retries.content = @retries
        doc.add_child(retries)
      end

      doc
    end
  end
end

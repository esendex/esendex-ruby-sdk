require 'nokogiri'

#  <message>
#    <to>$TO</to>
#    <body>$BODY</body>
#  </message>

module Esendex
  class Message
    attr_accessor :to, :body, :from, :type, :lang, :retries
    
    def initialize(to, body, from=nil, type='SMS', lang='en-GB', retries='3')
      @to = to
      @body = body
      @from = from
      @type = type
      @lang = lang
      @retries = retries
    end
    
    def xml_node
      @doc = Nokogiri::XML('<message/>')
                  
      to = Nokogiri::XML::Node.new 'to', @doc
      to.content = @to
      @doc.root.add_child(to)
      
      body = Nokogiri::XML::Node.new 'body', @doc
      body.content = @body
      @doc.root.add_child(body)

      type = Nokogiri::XML::Node.new 'type', @doc
      type.content = @type
      @doc.root.add_child(type)

      if @from
        from = Nokogiri::XML::Node.new 'from', @doc
        from.content = @from
        @doc.root.add_child(from)
      end

      add_voice_message_nodes if @type == 'Voice'
      
      @doc.root
    end

    def add_voice_message_nodes
      lang = Nokogiri::XML::Node.new 'lang', @doc
      lang.content = @lang
      @doc.root.add_child(lang)

      retries = Nokogiri::XML::Node.new 'retries', @doc
      retries.content = @retries
      @doc.root.add_child(retries)
    end
  end
end

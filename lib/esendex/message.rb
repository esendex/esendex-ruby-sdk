require 'nokogiri'

#  <message>
#    <to>$TO</to>
#    <body>$BODY</body>
#  </message>

module Esendex
  class Message
    attr_accessor :to, :body, :from, :characterset
    
    def initialize(to, body, from=nil, characterset=nil)
      @to = to
      @body = body
      @from = from
      @characterset = characterset.nil? ? 'Auto' : characterset
    end
    
    def xml_node
      doc = Nokogiri::XML('<message/>')
                  
      to = Nokogiri::XML::Node.new 'to', doc
      to.content = @to
      doc.root.add_child(to)
      
      body = Nokogiri::XML::Node.new 'body', doc
      body.content = @body
      doc.root.add_child(body)

      if @from
        from = Nokogiri::XML::Node.new 'from', doc
        from.content = @from
        doc.root.add_child(from)
      end

      if @characterset
        characterset = Nokogiri::XML::Node.new 'characterset', doc
        characterset.content = @characterset
        doc.root.add_child(characterset)
      end

      doc.root
    end
  end
end

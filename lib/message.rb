require 'rexml/document'
include REXML

#  <message>
#    <to>$TO</to>
#    <body>$BODY</body>
#  </message>

module Esendex
  class Message
    attr_accessor :to, :body, :from
    
    def initialize(to, body)
      self.to = to
      self.body = body
    end
    
    def xml_node
      doc = Document.new "<message/>" 
                  
      to = Element.new("to")
      to.text = self.to
      doc.root.elements << to
      
      body = Element.new("body")
      body.text = self.body
      doc.root.elements << body

      if self.from
        from = Element.new("from")
        from.text = self.from
        doc.root.elements << from
      end
      
      doc.root
    end
  end
end
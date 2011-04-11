require 'rexml/document'
require 'nokogiri'
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
      doc = Nokogiri::XML('<message/>')
                  
      to = Nokogiri::XML::Node.new 'to', doc
      to.content = self.to
      doc.root.add_child(to)
      
      body = Nokogiri::XML::Node.new 'body', doc
      body.content = self.body
      doc.root.add_child(body)

      if self.from
        from = Nokogiri::XML::Node.new 'from', doc
        from.content = self.from
        doc.root.add_child(from)
      end
      
      doc.root
    end
  end
end
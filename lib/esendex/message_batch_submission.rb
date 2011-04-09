require 'rexml/document'
include REXML

#<messages>
#  <accountreference>EX000000</accountreference>
#  <message>
#    <to>someone</to>
#    <body>$BODY</body>
#  </message>
#  <message>
#    <to>$TO_</to>
#    <body>$BODY</body>
#  </message>
#</messages>

module Esendex
  class MessageBatchSubmission
    attr_accessor :account_reference, :messages, :send_at
    
    def initialize(account_reference, messages)
      @account_reference = account_reference
      @messages = messages
      @send_at = send_at
    end
    
    def xml_node
      xml_doc = Document.new "<messages/>" 
                  
      account_reference = Element.new("accountreference")
      account_reference.text = @account_reference
      xml_doc.root.elements << account_reference

      if @send_at
        send_at = Element.new("sendat")
        send_at.text = @send_at.strftime("%Y-%m-%dT%H:%M:%S")
        xml_doc.root.elements << send_at
      end
      
      @messages.each do |message|
        xml_doc.root.elements << message.xml_node
      end
      
      xml_doc.root
    end
    
    def to_s
      self.xml_node.to_s
    end
  end
end
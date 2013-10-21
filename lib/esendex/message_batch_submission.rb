require 'nokogiri'

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
      raise AccountReferenceError unless account_reference
      raise StandardError, "Need at least one message" unless messages.kind_of?(Array) and not messages.empty?

      @account_reference = account_reference
      @messages = messages
    end
    
    def xml_node
      doc = Nokogiri::XML'<messages/>'
                  
      account_reference = Nokogiri::XML::Node.new 'accountreference', doc
      account_reference.content = self.account_reference
      doc.root.add_child(account_reference)

      if self.send_at
        send_at = Nokogiri::XML::Node.new 'sendat', doc
        send_at.content = self.send_at.strftime("%Y-%m-%dT%H:%M:%S")
        doc.root.add_child(send_at)
      end
      
      @messages.each do |message|
        doc.root.add_child(message.xml_node)
      end
      
      doc.root
    end
    
    def to_s
      self.xml_node.to_s
    end
  end
end
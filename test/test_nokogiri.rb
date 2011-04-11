require 'helper'
require 'Nokogiri'

class TestNokogiri < Test::Unit::TestCase
  should "get same from Nokogiri using XPath or CSS syntax" do
    
    xml_source = "<?xml version=\"1.0\" encoding=\"utf-8\"?><accounts xmlns=\"http://api.esendex.com/ns/\"><account id=\"2b4a326c-41de-4a57-a577-c7d742dc145c\" uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c\"><messagesremaining>100</messagesremaining></account></accounts>"
    
    ndoc = Nokogiri::XML(xml_source)
    
    node_value = ndoc.css("accounts account messagesremaining").count
    assert_equal 1, node_value

    node_value = ndoc.xpath('//api:accounts/api:account/api:messagesremaining', 'api' => 'http://api.esendex.com/ns/').count
    assert_equal 1, node_value
    
  end
end
  
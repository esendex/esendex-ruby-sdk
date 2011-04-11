require 'helper'

class TestMessage < Test::Unit::TestCase
  should "create a valid xml representation of a message" do
    target = Esendex::Message.new("07777111333", "Hello World")
    
    actual = target.xml_node
    
    assert_equal "07777111333", actual.at_xpath('//message/to').content
    assert_equal "Hello World", actual.at_xpath('//message/body').content
  end
  
  should "create a valid xml representation if from specified" do
    target = Esendex::Message.new("07777111333", "Hello World")
    target.from = "BilgeInc"
    
    actual = target.xml_node
    
    assert_equal "07777111333", actual.at_xpath('//message/to').content
    assert_equal "Hello World", actual.at_xpath('//message/body').content
    assert_equal "BilgeInc", actual.at_xpath('//message/from').content
    
  end
end
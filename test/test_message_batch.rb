require 'helper'

class TestMessageBatchSubmission < Test::Unit::TestCase
  should "format scheduled date time correctly" do
    # yyyy-MM-ddThh:mm:ss
    
    target_time = Time.local(2011, 4, 7, 15, 0, 0)
    
    submission = MessageBatchSubmission.new("EX1234556", [Message.new("0777111222", "I'm sending this in the future")])
    submission.send_at = target_time
    
    assert_equal "2011-04-07T15:00:00", submission.xml_node.at_xpath('//messages/sendat').content
  end
  
  should "contain multiple messages" do   
    submission = MessageBatchSubmission.new("EX1234556", [Message.new("0777111222", "I'm sending this in the future"), Message.new("0777111333", "I'm sending this in the future")])
    
    message_elements = submission.xml_node.xpath('//messages/message')
    
    assert_equal 2, message_elements.count
  end
end
require 'helper'
require 'nestful'
include Esendex

class TestAccount < Test::Unit::TestCase

  def raw_mock_connection   
    @user = "codechallenge@esendex.com"
    @password = "c0d3cha113ng3"
    @account_reference = "EX0068832"    
    connection = mock()
    connection.expects(:user=).with(@user)
    connection.expects(:password=).with(@password)
    connection.expects(:auth_type=).with(:basic)
    connection
  end
  
  def mock_connection
    connection = raw_mock_connection
    account_initialisation_response = mock()
    account_initialisation_response.expects(:body).returns("<?xml version=\"1.0\" encoding=\"utf-8\"?><accounts xmlns=\"http://api.esendex.com/ns/\"><account id=\"2b4a326c-41de-4a57-a577-c7d742dc145c\" uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c\"><balanceremaining domesticmessages=\"100\" internationalmessages=\"100\">$0.00</balanceremaining><reference>EX0068832</reference><address>447786204254</address><type>Professional</type><messagesremaining>100</messagesremaining><expireson>2015-12-31T00:00:00</expireson><role>PowerUser</role><defaultdialcode>44</defaultdialcode><settings uri=\"http://api.esendex.com/v1.0/accounts/2b4a326c-41de-4a57-a577-c7d742dc145c/settings\" /></account></accounts>")
    
    connection.expects(:get).with("/v0.1/accounts/#{@account_reference}").returns(account_initialisation_response)
    connection
  end
  
  should "validate account when a new one is created" do
    connection = mock_connection
    
    code_challenge_account = Account.new(@account_reference, @user, @password, connection)
    
    assert_equal 100, code_challenge_account.messages_remaining
  end
  
  should "raise an ForbiddenError when a 403 is returned from API" do
    connection = raw_mock_connection
    connection.stubs(:get).raises(Nestful::ForbiddenAccess.new nil)
    
    begin
      account = Account.new(@account_reference, @user, @password, connection)
    rescue Esendex::ForbiddenError
    end
  end
  
  should "send a message" do
    connection = mock_connection
    batch_id = "2b4a326c-41de-4a57-a577-c7d742dc145c"
    
    message_send_response = mock()
    message_send_response.expects(:body).returns("<?xml version=\"1.0\" encoding=\"utf-8\"?> <messageheaders batchid=\"#{batch_id}\" xmlns=\"http://api.esendex.com/ns/\"> <messageheader\ uri=\"http://api.esendex.com/v1.0/MessageHeaders/00000000-0000-0000-0000-000000000000\" id=\"00000000-0000-0000-0000-000000000000\" /></messageheaders>")
    connection.expects(:post).with("/v1.0/messagedispatcher", anything).returns(message_send_response)
    
    code_challenge_account = Account.new(@account_reference, @user, @password, connection)
    
    result = code_challenge_account.send_message(Message.new("447815777555", "Hello from the Esendex Ruby Gem"))
    
    assert_equal batch_id, result
  end
end

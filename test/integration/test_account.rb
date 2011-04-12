require 'helper'
include Esendex

class TestAccount < Test::Unit::TestCase
  should "validate account when a new one is created" do
    code_challenge_account = Account.new("EX0068832", "codechallenge@esendex.com", "c0d3cha113ng3")
    
    assert code_challenge_account.messages_remaining > 0
  end
  
  should "fail authorisation" do
    begin
      code_challenge_account = Account.new("EX0068832", "bilge", "bilge")
    rescue Esendex::ForbiddenError
    end
    
  end
  
  should "send a message" do
    code_challenge_account = Account.new("EX0068832", "codechallenge@esendex.com", "c0d3cha113ng3")
    
    batch_id = code_challenge_account.send_message(Message.new("447700900000", "Hello from the Esendex Ruby Gem"))
    
    assert batch_id
  end
end

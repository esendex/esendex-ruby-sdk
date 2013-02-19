require 'spec_helper'

describe ApiConnection do
  let(:api_connection) { ApiConnection.new }

  before(:each) do
    @connection = Nestful::Connection.new Esendex::API_HOST
    Nestful::Connection.stub(:new) { @connection }
    @connection.stub(:get) {}
    @connection.stub(:post) {}
    Esendex.configure do |config|
      config.username = random_string
      config.password = random_string
    end
  end

  describe "#initialise" do

    subject { ApiConnection.new }

    it "should set the username" do
      subject
      @connection.user.should eq(Esendex.username)
    end
    it "should set the password" do
      subject
      @connection.password.should eq(Esendex.password)
    end
    it "should set the auth to basic" do
      subject
      @connection.auth_type.should eq(:basic)
    end

  end


  describe "#get" do
    let(:url) { random_string }

    subject { api_connection.get url }
    
    it "should call get with headers" do
      @connection.should_receive(:get).with(url, api_connection.default_headers)
      subject
    end

    context "when 403 raised" do
      before(:each) do
        @connection.stub(:get) { raise Nestful::ForbiddenAccess.new(nil) }
      end
      it "raises an Esendex::ForbiddenError" do
        expect { subject }.to raise_error(Esendex::ForbiddenError)
      end
    end

  end

  describe "#post" do
    let(:url) { random_string }
    let(:body) { random_string }

    subject { api_connection.post url, body }
    
    it "should call post with headers" do
      @connection.should_receive(:post).with(url, body, api_connection.default_headers)
      subject
    end

    context "when 403 raised" do
      before(:each) do
        @connection.stub(:post) { raise Nestful::ForbiddenAccess.new(nil) }
      end
      it "raises an Esendex::ForbiddenError" do
        expect { subject }.to raise_error(Esendex::ForbiddenError)
      end
    end

  end
end
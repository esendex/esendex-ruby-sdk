require 'spec_helper'

describe ApiConnection do
  let(:api_connection) { ApiConnection.new }

  before(:each) do
    @connection = Nestful::Connection.new Esendex::API_HOST
    allow(Nestful::Connection).to receive(:new) { @connection }
    allow(@connection).to receive(:get) {}
    allow(@connection).to receive(:post) {}
    Esendex.configure do |config|
      config.username = random_string
      config.password = random_string
    end
  end

  describe "#initialise" do
    subject { ApiConnection.new }

    it "should set the username" do
      subject
      expect(@connection.user).to eq(Esendex.username)
    end
    
    it "should set the password" do
      subject
      expect(@connection.password).to eq(Esendex.password)
    end
    
    it "should set the auth to basic" do
      subject
      expect(@connection.auth_type).to eq(:basic)
    end
  end


  describe "#get" do
    let(:url) { random_string }

    subject { api_connection.get url }
    
    it "should call get with headers" do
      expect(@connection).to receive(:get).with(url, api_connection.default_headers)
      subject
    end

    context "when 403 raised" do
      before(:each) do
        allow(@connection).to receive(:get) { raise Nestful::ForbiddenAccess.new(nil) }
      end
      
      it "raises an ForbiddenError" do
        expect { subject }.to raise_error(ForbiddenError)
      end
    end
  end

  describe "#post" do
    let(:url) { random_string }
    let(:body) { random_string }

    subject { api_connection.post url, body }
    
    it "should call post with headers" do
      expect(@connection).to receive(:post).with(url, body, api_connection.default_headers)
      subject
    end

    context "when 403 raised" do
      before(:each) do
        allow(@connection).to receive(:post) { raise Nestful::ForbiddenAccess.new(nil) }
      end
      
      it "raises an ForbiddenError" do
        expect { subject }.to raise_error(ForbiddenError)
      end
    end
  end
end
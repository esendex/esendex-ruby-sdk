require 'spec_helper'
require 'net/http'

describe ApiConnection do
  let(:api_connection) { ApiConnection.new }

  before(:each) do
    @request = Nestful::Request.new(Esendex::API_HOST)
    allow(@request).to receive :execute

    Esendex.configure do |config|
      config.username = random_string
      config.password = random_string
    end
  end

  def expect_to_initialize_request_with(options)
    expect(Nestful::Request)
      .to receive(:new)
      .with(anything, hash_including(options))
      .and_return(@request)
  end

  describe "authorisation" do
    let(:url) { random_string }

    it "should set the username" do
      expect_to_initialize_request_with user: Esendex.username

      api_connection.get(url)
    end

    it "should set the password" do
      expect_to_initialize_request_with password: Esendex.password

      api_connection.get(url)
    end

    it "should set the auth to basic" do
      expect_to_initialize_request_with auth_type: :basic

      api_connection.get(url)
    end
  end

  describe "#get" do
    let(:url) { random_string }

    subject { api_connection.get(url) }

    it "should call get with headers" do
      expect_any_instance_of(Nestful::Resource)
        .to receive(:get).with(url, {}, hash_including(headers: { 'User-Agent' => Esendex.user_agent }))

      subject
    end

    context "when 403 raised" do
      before(:each) do
        allow_any_instance_of(Nestful::Resource).to receive(:get).and_raise Nestful::ForbiddenAccess.new(nil)
      end

      it "raises an ForbiddenError" do
        expect { subject }.to raise_error ForbiddenError
      end
    end
  end

  describe "#post" do
    let(:url) { random_string }
    let(:body) { random_string }

    subject { api_connection.post url, body }

    it "should call post with headers" do
      expect_any_instance_of(Nestful::Resource)
        .to receive(:post).with(url, {}, hash_including(body: body))

      subject
    end

    context "when 403 raised" do
      before(:each) do
        allow_any_instance_of(Nestful::Resource)
          .to receive(:post).and_raise Nestful::ForbiddenAccess.new(nil)
      end

      it "raises an ForbiddenError" do
        expect { subject }.to raise_error ForbiddenError
      end
    end
  end
end

require 'nestful'

module Esendex
  class ApiConnection

    def initialize
      @connection = Nestful::Connection.new(Esendex.api_host)
      @connection.user = Esendex.username
      @connection.password = Esendex.password
      @connection.auth_type = :basic
    end

    def default_headers
      { 'User-Agent' => Esendex.user_agent }
    end

    def get(url)
      @connection.get url, default_headers
    rescue => e
      raise Esendex::ApiErrorFactory.new.get_api_error(e)
    end

    def post(url, body)
      @connection.post url, body, default_headers
    rescue => e
      raise Esendex::ApiErrorFactory.new.get_api_error(e)
    end
  end
end

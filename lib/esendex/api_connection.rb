require 'nestful'

module Esendex
  class ApiConnection < Nestful::Resource
    endpoint Esendex::API_HOST

    def default_options
      {
        auth_type: :basic,
        user: Esendex.username,
        password: Esendex.password,
        headers: { 'User-Agent' => Esendex.user_agent }
      }
    end

    def get(url)
      super url, {}, default_options
    rescue => e
      raise Esendex::ApiErrorFactory.new.get_api_error(e)
    end

    def post(url, body)
      super url, {}, default_options.merge(body: body)
    rescue => e
      raise Esendex::ApiErrorFactory.new.get_api_error(e)
    end
  end
end

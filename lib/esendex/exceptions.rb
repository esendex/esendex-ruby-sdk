module Esendex
  class ApiErrorFactory
    def get_api_error(source_error)
      case source_error
      when Nestful::ForbiddenAccess
        ForbiddenError.new
      when Nestful::UnauthorizedAccess
        NotAuthorizedError.new
      else
        ApiError.new(source_error)
      end
    end
  end

  class ApiError < StandardError
  end

  class NotAuthorizedError < ApiError
  end

  class ForbiddenError < ApiError
  end

  class AccountReferenceError < ApiError
  end
end

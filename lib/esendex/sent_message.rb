module Esendex
  class SentMessage
    @load_body_function
    @cached_body

    def initialize(properties, load_body_function)
      properties.each do |key, value|
        define_singleton_method key, lambda { value }
      end
      @load_body_function = load_body_function
    end

    def body
      @cached_body ||= resolve_body()
    end

    def resolve_body()
      if summary.length < 50
        summary
      else
        @load_body_function[]
      end
    end

    private :resolve_body
  end
end

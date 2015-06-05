require "authentise/api/print"

module Authentise
  # Represents a streaming print iframe request
  class Print
    attr_accessor :model_url

    def initialize(model_url: nil)
      @model_url = model_url
    end

    def token_url
      @token_url ||= begin
        response = API::Print.create_token(
          model_url: model_url
        )
        response[:token_url]
      end
    end
  end
end

require "authentise/api"

module Authentise
  # TODO: Rename to Streaming
  class Upload
    attr_reader :stl_file, :email, :cents, :currency

    def initialize(stl_file: nil,
                   email: nil,
                   cents: nil,
                   currency: nil,
                   token: nil)
      @stl_file = stl_file
      @email = email
      @cents = cents
      @currency = currency
      @token = token
    end

    def token
      @token ||= API.create_token
    end

    def link_url
      @upload_url ||= API.upload_file(file: stl_file,
                                      token: token,
                                      email: email,
                                      cents: cents,
                                      currency: currency)
    end

    def status
      @status ||= API.get_status(token: token)
    end
  end
end

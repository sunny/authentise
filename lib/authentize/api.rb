require "json"
require "authentize/configuration"

module Authentize
  module API
    CREATE_TOKEN_URL = "https://widget.sendshapes.com:3000/api3/api_create_partner_token"
    UPLOAD_FILE_URL = "https://widget.sendshapes.com:3000/api3/api_upload_partner_stl"

    module_function

    def create_token
      response = get(CREATE_TOKEN_URL,
                     api_key: Authentize.configuration.secret_partner_key)
      json = JSON.parse(response)
      data = json["data"]
      data["token"]
    end

    def upload_file(file:, token:, email:, cents:, currency: "USD")
      response = post(UPLOAD_FILE_URL,
                      api_key: Authentize.configuration.secret_partner_key,
                      token: token,
                      receiver_email: email,
                      print_value: cents,
                      print_value_currency: currency,
                      stl_file: file)
      json = JSON.parse(response)
      data = json["data"]
      data["ssl_token_link"]
    end
  end
end

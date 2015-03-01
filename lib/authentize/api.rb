require "json"
require "rest-client"
require "authentize/configuration"

module Authentize
  module API
    class Error < RuntimeError; end

    CREATE_TOKEN_URL = "https://widget.sendshapes.com:3443/api3/api_create_partner_token"
    UPLOAD_FILE_URL = "https://widget.sendshapes.com:3443/api3/api_upload_partner_stl"

    module_function

    def create_token
      response = RestClient.get(CREATE_TOKEN_URL,
                                api_key: Authentize.configuration.secret_partner_key)
      data = parse(response)
      data["token"]
    end

    def upload_file(file: nil, token: nil, email: nil, cents: nil, currency: "USD")
      response = RestClient.post(UPLOAD_FILE_URL,
                                 api_key: Authentize.configuration.secret_partner_key,
                                 token: token,
                                 receiver_email: email,
                                 print_value: cents,
                                 print_value_currency: currency,
                                 stl_file: file)
      data = parse(response)
      data["ssl_token_link"]
    end

    def parse(response)
      json = JSON.parse(response)
      if json["status"]["code"] != "ok"
        fail Error.new(json["status"]["extended_description"])
      end
      json["data"]
    end
  end
end

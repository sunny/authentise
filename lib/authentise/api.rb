require "json"
require "rest-client"
require "authentise/configuration"

module Authentise
  module API
    class Error < RuntimeError; end

    CREATE_TOKEN_URL = "https://widget.sendshapes.com:3443/api3/api_create_partner_token"
    UPLOAD_FILE_URL = "https://widget.sendshapes.com:3443/api3/api_upload_partner_stl"
    STATUS_URL = "https://widget.sendshapes.com:3443/api3/api_get_partner_print_status"

    module_function

    def create_token
      params = {
        api_key: Authentise.configuration.secret_partner_key
      }
      response = RestClient.get(CREATE_TOKEN_URL, params: params)
      data = parse(response)
      data["token"]
    end

    def upload_file(file: nil, token: nil, email: nil, cents: nil, currency: "USD")
      params = {
        api_key: Authentise.configuration.secret_partner_key,
        token: token,
        receiver_email: email,
        print_value: cents,
        print_value_currency: currency,
        stl_file: file
      }
      response = RestClient.post(UPLOAD_FILE_URL, params, accept: :json)
      data = parse(response)
      data["ssl_token_link"]
    end

    # Returns a status hash for the given token if the print has started.
    # /!\ Do not call this more than once every 15 seconds.
    #
    # `:printing_job_status` can be one of:
    # - `warming_up`
    # - `printing`
    # - `failure`
    # - `success`
    # - `confirmed_success`
    # - `confirmed_failure`
    def get_status(token: nil)
      params = {
        api_key: Authentise.configuration.secret_partner_key,
        token: token
      }
      response = RestClient.get(STATUS_URL, params: params)
      data = parse(response)
      {
        printing_job_status: data["printing_job_status"].downcase,
        printing_percentage: data["printing_percentage"],
        minutes_left: data["minutes_left"],
        message: data["message"]
      }
    end

    private_class_method

    def parse(response)
      json = JSON.parse(response)
      if json["status"] and json["status"]["code"] != "ok"
        fail Error, json["status"]["extended_description"]
      elsif json["data"]
        json["data"]
      else
        fail Error, "JSON with no data: #{response}"
      end
    end
  end
end

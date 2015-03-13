require "json"
require "rest-client"
require "authentise/configuration"

module Authentise
  module API
    class Error < RuntimeError; end

    CREATE_TOKEN_PATH = "api3/api_create_partner_token"
    UPLOAD_FILE_PATH = "api3/api_upload_partner_stl"
    STATUS_PATH = "api3/api_get_partner_print_status"

    module_function

    def create_token
      url = "#{host}/#{CREATE_TOKEN_PATH}"
      params = {
        api_key: Authentise.configuration.secret_partner_key
      }
      response = RestClient.get(url, params: params)
      data = parse(response)
      data["token"]
    end

    def upload_file(file: nil, token: nil, email: nil, cents: nil, currency: "USD")
      url = "#{host}/#{UPLOAD_FILE_PATH}"
      params = {
        api_key: Authentise.configuration.secret_partner_key,
        token: token,
        receiver_email: email,
        print_value: cents,
        print_value_currency: currency,
        stl_file: file
      }
      response = RestClient.post(url, params, accept: :json)
      data = parse(response)

      iframe_link(data["ssl_token_link"])
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
      url = "#{host}/#{STATUS_PATH}"
      params = {
        api_key: Authentise.configuration.secret_partner_key,
        token: token
      }
      response = RestClient.get(url, params: params)
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

    def host
      if Authentise.configuration.use_ssl
        "https://widget.sendshapes.com:3443"
      else
        "http://widget.sendshapes.com:3000"
      end
    end

    def iframe_link(url)
      if Authentise.configuration.use_ssl
        url
      else
        url.sub(/^https:/, 'http:')
      end
    end

  end
end

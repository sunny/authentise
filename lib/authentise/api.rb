require "json"
require "rest-client"
require "authentise/configuration"

module Authentise
  # Module for all API-Related
  module API
    # Common Error
    class Error < RuntimeError; end

    # 404 Error
    class NotFoundError < Error; end

    # Other response codes
    class UnknownResponseCodeError < Error
      def initialize(code, message)
        super("(#{code}) #{message}")
      end
    end

    module_function

    # DEPRECATED, use Authentise::API::Print.create_token(…)
    def create_token
      url = "#{host}/api3/api_create_partner_token"
      params = {
        api_key: Authentise.configuration.secret_partner_key,
      }
      response = RestClient.get(url, params: params)
      data = parse(response)
      data["token"]
    end

    # DEPRECATED, use Authentise::API::Print.create_token(…)
    def upload_file(token: nil,
                    file: nil,
                    email: nil,
                    cents: nil,
                    currency: "USD")
      url = "#{host}/api3/api_upload_partner_stl"
      params = {
        api_key: Authentise.configuration.secret_partner_key,
        token: token,
        receiver_email: email,
        print_value: cents,
        print_value_currency: currency,
        stl_file: file,
      }
      response = RestClient.post(url, params, accept: :json)
      data = parse(response)

      if Authentise.configuration.use_ssl
        data["ssl_token_link"]
      else
        data["token_link"]
      end
    end

    # DEPRECATED
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
      url = "#{host}/api3/api_get_partner_print_status"
      params = {
        api_key: Authentise.configuration.secret_partner_key,
        token: token,
      }
      response = RestClient.get(url, params: params)
      data = parse(response)
      {
        printing_job_status_name: data["printing_job_status_name"].downcase,
        printing_percentage: data["printing_percentage"],
        minutes_left: data["minutes_left"],
        message: data["message"],
      }
    end

    # private

    def parse(response)
      json = JSON.parse(response)
      if json["status"] && json["status"]["code"] != "ok"
        fail Error, json["status"]["extended_description"]
      elsif json["data"]
        json["data"]
      else
        fail Error, "JSON with no data: #{response}"
      end
    end
    private_class_method :parse

    def host
      if Authentise.configuration.use_ssl
        "https://widget.sendshapes.com:3443"
      else
        "http://widget.sendshapes.com:3000"
      end
    end
    private_class_method :host
  end
end

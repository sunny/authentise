require "authentise/api"

module Authentise
  module API
    # Calls to create a user and authenticate over the API
    module Users
      module_function

      # Create a new user to use the API.
      #
      # Params:
      # - email
      # - name
      # - username
      # - password
      #
      # Returns a hash with:
      # - url: URL to the new user
      # - uuid: unique id for this user
      def create_user(params)
        url = "https://users.authentise.com/users/"
        options = {
          accept: :json,
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.post(url, params, options) do |response, _request, _result|
          json = JSON.parse(response)
          if response.code == 201
            {
              url: json["uri"],
              uuid: json["uuid"],
            }
          else
            fail UnknownResponseCodeError.new(response.code, response)
          end
        end
      end

      # Create a new session to use in other API calls.
      #
      # Params:
      # - username
      # - password
      #
      # Returns a hash with:
      # - token: cookie token to add to the following API cooke calls
      def create_session(params)
        url = "https://users.authentise.com/sessions/"
        options = {
          accept: :json,
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.post(url, params, options) do |response, _request, _result|
          if response.code == 201
            {
              token: response.cookies["session"],
            }
          else
            fail UnknownResponseCodeError.new(response.code, response)
          end
        end
      end
    end
  end
end

require "authentise/api"

module Authentise
  module API
    module Users
      module_function

      def create_user(params)
        url = "https://users.authentise.com/users/"
        RestClient.post(url, params, accept: :json) do |response,
                                                        request,
                                                        result|
          json = JSON.parse(response)
          if response.code == 201
            {
              url: json["uri"],
              uuid: json["uuid"]
            }
          else
            raise API::Error.new(json["message"])
          end
        end
      end

      def create_session(params)
        url = "https://users.authentise.com/sessions/"
        RestClient.post(url, params, accept: :json) do |response,
                                                        request,
                                                        result|
          json = JSON.parse(response)
          if response.code == 201
            {
              session_token: response.cookies["session"]
            }
          else
            raise API::Error.new(json["message"])
          end
        end
      end
    end
  end
end

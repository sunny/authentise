require "authentise/api"

module Authentise
  module API
    module Print
      module_function

      def create_token(receiver_email: nil,
                       model_url: nil,
                       print_value: nil,
                       print_value_currency: nil,
                       partner_job_id: nil)
        url = "https://print.authentise.com/token/"
        body = {
          api_key: Authentise.configuration.secret_partner_key,
          model: model_url,
          receiver_email: receiver_email,
          print_value: print_value,
          print_value_currency: print_value_currency,
          partner_job_id: partner_job_id
        }.to_json
        options = {
          content_type: :json,
          accept: :json,
        }
        RestClient.post(url, body, options) do |response, _request, _result|
          if response.code == 201
            {
              url: response.headers[:x_token_location]
            }
          else
            raise API::Error.new(JSON.parse(response)["message"])
          end
        end
      end

    end
  end
end

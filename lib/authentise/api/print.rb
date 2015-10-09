require "authentise/api"

module Authentise
  module API
    # Calls to the print streaming API
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
          partner_job_id: partner_job_id,
        }.to_json
        RestClient.post(url, body, rest_client_options) do |response, _, _|
          if response.code == 201
            { url: response.headers[:x_token_location] }
          else
            fail API::Error, response
          end
        end
      end

      private

      def rest_client_options
        {
          content_type: :json,
          accept: :json,
          open_timeout: 2,
          timeout: 2,
        }
      end
    end
  end
end

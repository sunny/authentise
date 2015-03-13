require "spec_helper"

describe Authentise::API do
  describe ".create_token" do
    it "returns a token from the API" do
      stub_request(:get, "https://widget.sendshapes.com:3443/api3/api_create_partner_token?api_key=test")
        .to_return(status: 200, body: '{"data":{"token":"meh"}}')

      Authentise::API.create_token.must_equal "meh"
    end
  end

  describe ".upload_file" do
    it "returns a URL" do
      api_url = "https://widget.sendshapes.com:3443/api3/api_upload_partner_stl"
      request_body = { "api_key" => "test",
                       "print_value" => "100",
                       "print_value_currency" => "EUR",
                       "receiver_email" => "example@example.com",
                       "stl_file" => "",
                       "token"=>"meh"}
      request_headers = { "Accept" => "application/json",
                          "Accept-Encoding" => "gzip, deflate",
                          "Content-Length" => "110",
                          "Content-Type" => "application/x-www-form-urlencoded",
                          "User-Agent" => "Ruby"}

      stub_request(:post, api_url)
        .with(body: request_body, headers: request_headers)
        .to_return(status: 200,
                   body: '{"data":{"ssl_token_link":"https://bah"}}')

      returned = Authentise::API.upload_file(file: nil,
                                             token: "meh",
                                             email: "example@example.com",
                                             cents: 100,
                                             currency: "EUR")
      returned.must_equal "https://bah"
    end

    it "transforms the url if not using ssl" do
      api_url = "http://widget.sendshapes.com:3000/api3/api_upload_partner_stl"
      stub_request(:post, api_url)
        .to_return(body: '{"data":{"ssl_token_link":"https://bah"}}')

      Authentise.configuration.stub :use_ssl, false do
        returned = Authentise::API.upload_file(file: nil,
                                               token: "meh",
                                               email: "example@example.com",
                                               cents: 100,
                                               currency: "EUR")
        returned.must_equal "http://bah"
      end
    end
  end

  describe ".get_status" do
    it "returns a status hash" do
      api_url = "https://widget.sendshapes.com:3443/api3/api_get_partner_print_status?api_key=test&token=meh"
      request_body = { "api_key" => "test",
                       "print_value" => "100",
                       "print_value_currency" => "EUR",
                       "receiver_email" => "example@example.com",
                       "stl_file" => "",
                       "token"=>"meh"}
      body = {
        data: {
          printing_job_status: "WARMING_UP",
          printing_percentage: 20,
          minutes_left: 5,
          message: "",
        }
      }

      stub_request(:get, api_url)
        .to_return(status: 200, body: body.to_json)

      returned = Authentise::API.get_status(token: "meh")
      returned.must_equal(
        printing_job_status: "warming_up",
        printing_percentage: 20,
        minutes_left: 5,
        message: ""
      )
    end
  end
end

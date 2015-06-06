require "spec_helper"
require "authentise/api/print"

describe Authentise::API::Print do

  describe "create_token" do
    it "returns a token_url" do
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
      }
      request_body = {
        api_key: "test",
        model: "http://example.com/model/42",
        receiver_email: "example@example.com",
        print_value: 42,
        print_value_currency: "EUR",
        partner_job_id: 43,
      }.to_json

      response_headers = {
        "X-Token-Location" => "http://example.com/token",
      }

      stub_request(:post, "https://print.authentise.com/token/")
        .with(body: request_body, headers: request_headers)
        .to_return(status: 201, headers: response_headers)

      returned = Authentise::API::Print.create_token(
        model_url: "http://example.com/model/42",
        receiver_email: "example@example.com",
        print_value: 42,
        print_value_currency: "EUR",
        partner_job_id: 43,
      )

      returned.must_equal(
        url: "http://example.com/token",
      )
    end

    it "raises errors" do
      stub_request(:post, "https://print.authentise.com/token/")
        .to_return(status: 400, body: "Some test error")

      assert_raises Authentise::API::Error do
        Authentise::API::Print.create_token(
          model_url: "http://example.com/model/42",
        )
      end
    end
  end
end

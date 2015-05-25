require "spec_helper"
require "authentise/api/warehouse"

describe Authentise::API::Warehouse do
  describe ".post_model" do
    it "returns locations" do
      request_body = {
        "name" => "Test",
        "callback" => {
          "url" => "http://example.com/callback",
          "method" => "POST",
        }
      }
      request_headers = { "Accept" => "application/json" }

      response_headers = {
        "Location" => "http://example.com/1",
        "X-Upload-Location" => "http://example.com/2"
      }

      stub_request(:post, "https://models.authentise.com/model/")
        .with(body: request_body, headers: request_headers)
        .to_return(status: 200, headers: response_headers)

      returned = Authentise::API::Warehouse.post_model(
        name: "Test",
        callback: {
          url: "http://example.com/callback",
          method: "POST"
        }
      )
      returned.must_equal(
        model_url: "http://example.com/1",
        upload_url: "http://example.com/2"
      )
    end
  end
end

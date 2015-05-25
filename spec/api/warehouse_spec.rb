require "spec_helper"
require "authentise/api/warehouse"

describe Authentise::API::Warehouse do
  describe "post_model" do
    it "returns locations" do
      request_body = {
        "name" => "Test"
      }
      request_headers = {
        "Accept" => "application/json",
        # "Accept-Encoding" => "gzip, deflate",
        # "Content-Length" => "15",
        "Content-Type" => "application/json",
        "Cookie" => "session=f45k",
        # "User-Agent" => "Ruby",
      }

      response_headers = {
        "Location" => "http://example.com/1",
        "X-Upload-Location" => "http://example.com/2"
      }

      stub_request(:post, "https://models.authentise.com/model/")
        .with(body: request_body.to_json, headers: request_headers)
        .to_return(status: 201, headers: response_headers)

      returned = Authentise::API::Warehouse.create_model(
        name: "Test",
        session_token: "f45k"
      )
      returned.must_equal(
        model_url: "http://example.com/1",
        upload_url: "http://example.com/2"
      )
    end

    it "raises errors" do
      skip
    end
  end

  describe "put_file" do
    it "returns true" do
      skip
    end

    it "raises errors" do
      skip
    end

  end

  describe "get_model" do
    it "returns a model" do
      skip
    end

    it "raises errors" do
      skip
    end

  end

  describe "get_models" do
    it "returns models" do
      skip
    end

    it "raises errors" do
      skip
    end
  end
end

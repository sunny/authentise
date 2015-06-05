require "spec_helper"
require "authentise/api/print"

describe Authentise::API::Print do
  before do
    @response_error_body = {
      message: "Some test error"
    }.to_json
  end

  describe "create_token" do
    before do
      @request_body = {
        api_key: "test",
        model: "http://example.com/model/42",
      }.to_json
      @request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
      }
      @response_headers = {
        "Location" => "http://example.com/1",
        "X-Upload-Location" => "http://example.com/2",
      }
    end

    it "returns a token_url" do
      stub_request(:post, "https://print.authentise.com/token/")
        .with(body: @request_body, headers: @request_headers)
        .to_return(status: 201, headers: @response_headers)

      returned = Authentise::API::Print.create_token(
        model_url: "http://example.com/model/42"
      )
    end

    it "raises errors" do
      stub_request(:post, "https://print.authentise.com/token/")
        .with(body: @request_body, headers: @request_headers)
        .to_return(status: 400, body: @response_error_body)

      assert_raises Authentise::API::Error do
        Authentise::API::Print.create_token(
          model_url: "http://example.com/model/42"
        )
      end
    end
  end
end
require "spec_helper"
require "authentise/api/warehouse"

describe Authentise::API::Warehouse do
  before do
    @response_error_body = {
      message: "Some test error"
    }.to_json
  end

  describe "post_model" do
    before do
      @request_body = {
        "name" => "Test"
      }
      @request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Cookie" => "session=f45k",
      }
      @response_headers = {
        "Location" => "http://example.com/1",
        "X-Upload-Location" => "http://example.com/2"
      }
    end

    it "returns locations" do
      stub_request(:post, "https://models.authentise.com/model/")
        .with(body: @request_body.to_json, headers: @request_headers)
        .to_return(status: 201, headers: @response_headers)

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
      stub_request(:post, "https://models.authentise.com/model/")
        .with(body: @request_body.to_json, headers: @request_headers)
        .to_return(status: 400, body: @response_error_body)

      assert_raises Authentise::API::Error do
        Authentise::API::Warehouse.create_model(
          name: "Test",
          session_token: "f45k"
        )
      end
    end
  end

  describe "put_file" do
    before do
      @request_body = "contents of example.stl\n"
    end

    it "returns true" do
      request_headers = {
        'Content-Type' => 'application/octet-stream'
      }
      stub_request(:put, "https://example.com/")
        .with(body: @request_body, headers: request_headers)
        .to_return(status: 200)

      response = Authentise::API::Warehouse.put_file(
        url: "https://example.com/",
        path: "spec/fixtures/example.stl"
      )

      response.must_equal(true)
    end

    it "raises errors" do
      stub_request(:put, "https://example.com/")
        .with(body: @request_body)
        .to_return(status: 400, body: @response_error_body)

      assert_raises Authentise::API::Error do
        Authentise::API::Warehouse.put_file(
          url: "https://example.com/",
          path: "spec/fixtures/example.stl"
        )
      end
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

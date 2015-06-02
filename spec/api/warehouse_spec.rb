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
    before do
      @url = "https://models.authentise.com/model/424242/"
      @request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Cookie" => "session=f56"
      }
      @response_body = {
        name: "Test",
        status: "processing",
        snapshot: "http://example.com/snapshot",
        content: "http://example.com/content",
        "analyses.manifold" => true,
        created: "2015-05-29 16:12:12.991340",
        updated: "2015-05-29 16:12:13.991340",
        parents: ["http://example.com/model/1", "http://example.com/model/2"],
        children: ["http://example.com/model/1"],
      }.to_json
    end

    it "returns a model" do
      stub_request(:get, @url)
        .with(headers: @request_headers)
        .to_return(body: @response_body, status: 200)

      response = Authentise::API::Warehouse.get_model(url: @url,
                                                      session_token: "f56")
      response.must_equal(
        url: @url,
        uuid: "424242",
        name: "Test",
        status: "processing",
        snapshot_url: "http://example.com/snapshot",
        content_url: "http://example.com/content",
        manifold: true,
        created_at: Time.local(2015, 5, 29, 16, 12, 12, 991340),
        updated_at: Time.local(2015, 5, 29, 16, 12, 13, 991340),
        parents_urls: ["http://example.com/model/1",
                       "http://example.com/model/2"],
        children_urls: ["http://example.com/model/1"]
      )
    end

    it "accepts a uuid instead of a url" do
      stub_request(:get, @url)
        .with(headers: @request_headers)
        .to_return(body: @response_body, status: 200)

      response = Authentise::API::Warehouse.get_model(uuid: "424242",
                                                      session_token: "f56")
      response.must_equal(
        url: @url,
        uuid: "424242",
        name: "Test",
        status: "processing",
        snapshot_url: "http://example.com/snapshot",
        content_url: "http://example.com/content",
        manifold: true,
        created_at: Time.local(2015, 5, 29, 16, 12, 12, 991340),
        updated_at: Time.local(2015, 5, 29, 16, 12, 13, 991340),
        parents_urls: ["http://example.com/model/1",
                       "http://example.com/model/2"],
        children_urls: ["http://example.com/model/1"]
      )
    end

    it "raises errors" do
      stub_request(:get, @url)
        .with(headers: @request_headers)
        .to_return(body: "", status: 404)

      assert_raises Authentise::API::NotFoundError do
        Authentise::API::Warehouse.get_model(url: @url,
                                             session_token: "f56")
      end
    end
  end

  # describe "get_models" do
  #   before do
  #     @request_headers = {
  #       "Accept" => "application/json",
  #       "Content-Type" => "application/json",
  #       "Cookie" => "session=e56",
  #     }
  #     @response_body = [{
  #       name: "Test",
  #       status: "processing",
  #       snapshot: "http://example.com/snapshot",
  #       content: "http://example.com/content",
  #       "analyses.manifold" => true,
  #       created: "2015-05-29 16:12:12.991340",
  #       updated: "2015-05-29 16:12:13.991340",
  #       parents: ["http://example.com/model/1", "http://example.com/model/2"],
  #       children: ["http://example.com/model/1"],
  #     }].to_json
  #   end

  #   it "returns models" do
  #     stub_request(:get, "https://models.authentise.com/model/").
  #       with(headers: @request_headers)
  #       .to_return(body: @response_body, status: 200)

  #     response = Authentise::API::Warehouse.get_models(session_token: "e56")
  #     response.must_equal [
  #       {
  #         name: "Test",
  #         status: "processing",
  #         snapshot_url: "http://example.com/snapshot",
  #         content_url: "http://example.com/content",
  #         manifold: true,
  #         created_at: Time.local(2015, 5, 29, 16, 12, 12, 991340),
  #         updated_at: Time.local(2015, 5, 29, 16, 12, 13, 991340),
  #         parents_urls: ["http://example.com/model/1",
  #                        "http://example.com/model/2"],
  #         children_urls: ["http://example.com/model/1"]
  #       }
  #     ]
  #   end

  #   it "adds query parameters" do
  #     skip
  #   end

  #   it "raises errors" do
  #     skip
  #   end
  # end

  describe "create_snapshot" do
    before do
      @request_body = {
        samples: 1,
        layer: 10,
        color: "#ff7f00",
        height: 480,
        width: 640,
        x: 0,
        y: 1,
        z: 2,
        u: 3,
        v: 4,
        w: 5,
        callback: { url: "http://my.example.com/processing/done",
                    method: "POST" }
      }
      @request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Cookie" => "session=f00",
      }
    end

    it "returns snapshot data" do
      response_headers = {
        "Location" => "http://example.com/model/4242/snapshot/1212/"
      }

      stub_request(:post, "https://models.authentise.com/model/4242/snapshot/")
        .with(body: @request_body, headers: @request_headers)
        .to_return(status: 201, headers: response_headers)

      response = Authentise::API::Warehouse.create_snapshot(
        session_token: "f00",
        model_uuid: "4242",
        samples: 1,
        layer: 10,
        color: "#ff7f00",
        height: 480,
        width: 640,
        x: 0,
        y: 1,
        z: 2,
        u: 3,
        v: 4,
        w: 5,
        callback: { url: "http://my.example.com/processing/done",
                    method: "POST" }
      )

      response.must_equal(
        url: "http://example.com/model/4242/snapshot/1212/"
      )
    end
  end

  describe "get_snapshot" do
    before do
      @request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Cookie" => "session=z90",
      }
      @response_body = {
        status: "snapshot_rendering",
        samples: 1,
        layer: 1,
        color: "#ff7f00",
        height: 480,
        width: 640,
        x: 0,
        y: 1,
        z: 2,
        u: 3,
        v: 4,
        w: 5,
        slice_height: nil,
        created: "2015-05-13 22:18:22.658536",
        content: "https://example.com/content_url"
      }.to_json
    end

    it "returns snapshot data" do
      stub_request(:get, "https://models.authentise.com/model/42/snapshot/43/")
        .with(headers: @request_headers)
        .to_return(status: 200, body: @response_body)

      response = Authentise::API::Warehouse.get_snapshot(
        url: "https://models.authentise.com/model/42/snapshot/43/",
        session_token: "z90"
      )
      response.must_equal(
        status: "snapshot_rendering",
        samples: 1,
        layer: 1,
        color: "#ff7f00",
        height: 480,
        width: 640,
        x: 0,
        y: 1,
        z: 2,
        u: 3,
        v: 4,
        w: 5,
        slice_height: nil,
        created_at: Time.local(2015, 05, 13, 22, 18, 22, 658536),
        content_url: "https://example.com/content_url"
      )
    end
  end
end

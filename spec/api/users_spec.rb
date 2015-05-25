require "spec_helper"
require "authentise/api/users"

describe Authentise::API::Users do
  describe "create_user" do
    it "returns url and uuid" do
      request_body = {
        email: "test@example.com",
        name: "Test User",
        username: "testuser",
        password: "password",
      }
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/x-www-form-urlencoded",
      }
      response_body = {
        name: "Test User",
        username: "testuser",
        uri: "https://example.com/user/1111",
        uuid: "1111",
      }.to_json

      stub_request(:post, "https://users.authentise.com/users/")
        .with(body: request_body, headers: request_headers)
        .to_return(status: 201, body: response_body)

      returned = Authentise::API::Users.create_user(
        email: "test@example.com",
        name: "Test User",
        username: "testuser",
        password: "password"
      )
      returned.must_equal(
        url: "https://example.com/user/1111",
        uuid: "1111"
      )
    end

    it "raises errors" do
      skip
    end

  end

  describe "create_session" do
    it "returns a token" do
      request_body = {
        username: "testuser",
        password: "password",
      }
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
      response_headers = {
        "Set-Cookie" => "session=f4242aef; " + \
                        "expires=Thu, 27-Apr-2017 08:49:20 GMT; " + \
                        "path=/; " + \
                        "domain=authentise.com",
      }

      stub_request(:post, "https://users.authentise.com/sessions/")
        .with(body: request_body, headers: request_headers)
        .to_return(status: 201, body: "", headers: response_headers)

      returned = Authentise::API::Users.create_session(
        username: "testuser",
        password: "password"
      )
      returned.must_equal(
        token: "f4242aef"
      )
    end

    it "raises errors" do
      skip
    end

  end
end

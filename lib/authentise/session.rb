require "authentise/api/users"

module Authentise
  # Represents a user's session to use the API with a session cookie
  class Session
    attr_reader :username,
                :password,
                :token

    def initialize(username: nil,
                   password: nil)
      @username = username
      @password = password
    end

    def create
      response = API::Users.create_session(
        username: username,
        password: password
      )
      @token = response[:session_token]
    end
  end
end

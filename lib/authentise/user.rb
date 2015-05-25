require "authentise/api"

module Authentise
  # Represents a user that can use the API
  class User
    attr_reader :email,
                :name,
                :username,
                :password,
                :url,
                :uuid

    def initialize(email: nil,
                   name: nil,
                   username: nil,
                   password: nil)
      @email = email
      @name = name
      @username = username
      @password = password
    end

    def create
      response = API::Users.create_user(
        email: email,
        name: name,
        username: username,
        password: password
      )
      @url = response[:url]
      @uuid = response[:uuid]
    end
  end
end

require "spec_helper"

module Authentise
  describe User do
    let(:user) { User.new(email: "foo@foo.com",
                                      name: "Bob",
                                      username: "bob",
                                      password: "builder") }

    describe "#email" do
      it { user.email.must_equal "foo@foo.com" }
    end

    describe "#name" do
      it { user.name.must_equal "Bob" }
    end

    describe "#username" do
      it { user.username.must_equal "bob" }
    end

    describe "#password" do
      it { user.password.must_equal "builder" }
    end

    describe "#create" do
      it "assigns a token from the API" do
        response = {
          url: "http://exampkle.com/user/4242/",
          uuid: "4242"
        }
        API::Users.stub :create_user, response do
          result = user.create
          result.must_equal true

          user.url.must_equal "http://exampkle.com/user/4242/"
          user.uuid.must_equal "4242"
        end
      end
    end
  end
end

require "spec_helper"

module Authentise
  describe Session do
    let(:session) { Session.new(username: "bob",
                                password: "builder") }

    describe "#username" do
      it { session.username.must_equal "bob" }
    end

    describe "#password" do
      it { session.password.must_equal "builder" }
    end

    describe "#create" do
      it "assigns a token from the API" do
        response = { token: "zf300" }
        API::Users.stub :create_session, response do
          result = session.create
          result.must_equal true

          session.token.must_equal "zf300"
        end
      end
    end
  end
end

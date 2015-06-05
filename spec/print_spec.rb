require "spec_helper"
require "authentise/print"

module Authentise
  describe Print do
    let(:print) do
      Print.new(model_url: "https://example.com/model/1")
    end

    describe "#model_url" do
      it { print.model_url.must_equal "https://example.com/model/1" }
    end

    describe "#token_url" do
      it "returns a url from the API" do
        response = {
          token_url: "https://bah",
        }
        API::Print.stub :create_token, response do
          print.token_url.must_equal "https://bah"
        end
      end
    end
  end
end

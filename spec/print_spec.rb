require "spec_helper"
require "authentise/print"

module Authentise
  describe Print do
    let(:print) do
      Print.new(model_url: "https://example.com/model/1",
                receiver_email: "example@example.com",
                print_value: 42,
                print_value_currency: "EUR",
                partner_job_id: 43)
    end

    describe "#url" do
      it "returns a url from the API" do
        response = {
          url: "https://bah",
        }
        API::Print.stub :create_token, response do
          print.url.must_equal "https://bah"
        end
      end
    end

    describe "#model_url" do
      it { print.model_url.must_equal "https://example.com/model/1" }
    end

    describe "#receiver_email" do
      it { print.receiver_email.must_equal "example@example.com" }
    end

    describe "#print_value" do
      it { print.print_value.must_equal 42 }
    end

    describe "#print_value_currency" do
      it { print.print_value_currency.must_equal "EUR" }
    end

    describe "#partner_job_id" do
      it { print.partner_job_id.must_equal 43 }
    end

  end
end

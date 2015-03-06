require "spec_helper"

describe Authentize::Upload do
  let(:upload) {
    Authentize::Upload.new(email: "example@example.com",
                                     currency: "EUR",
                                     cents: 1_00)
  }

  describe "#token" do
    it "returns a token from the API" do
      Authentize::API.stub :create_token, "meh" do
        upload.token.must_equal "meh"
      end
    end
  end

  describe '#link_url' do
    it "returns a token from the API" do
      upload.stub :token, "meh" do
        Authentize::API.stub :upload_file, "http://bah" do
          upload.link_url.must_equal "http://bah"
        end
      end
    end
  end

  describe '#status' do
    it "returns a status from the API" do
      upload.stub :token, "meh" do
        Authentize::API.stub :upload_file, "stats…" do
          upload.link_url.must_equal "stats…"
        end
      end
    end
  end
end

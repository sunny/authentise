require "spec_helper"

# DEPRECATED

module Authentise
  describe Upload do
    let(:upload) {
      Upload.new(email: "example@example.com",
                                       currency: "EUR",
                                       cents: 1_00)
    }

    describe "#token" do
      it "returns a token from the API" do
        API.stub :create_token, "meh" do
          upload.token.must_equal "meh"
        end
      end
    end

    describe '#link_url' do
      it "returns a token from the API" do
        upload.stub :token, "meh" do
          API.stub :upload_file, "https://bah" do
            upload.link_url.must_equal "https://bah"
          end
        end
      end
    end

    describe '#status' do
      it "returns a status from the API" do
        upload.stub :token, "meh" do
          API.stub :upload_file, "stats…" do
            upload.link_url.must_equal "stats…"
          end
        end
      end
    end
  end
end

require "spec_helper"

describe Authentise::Model do
  let(:model) { Authentise::Model.new(name: "Test") }

  describe "#name" do
    it { model.name.must_equal "Test" }
  end

  describe "#create" do
    it "returns urls from the API" do
      response = {
        upload_url: "https://bah",
        model_url: "https://beh"
      }
      Authentise::API::Warehouse.stub :create_model, response do
        result = model.create
        result.must_equal true

        model.upload_url.must_equal "https://bah"
        model.url.must_equal "https://beh"
      end
    end
  end

  describe "#send_file" do
    it "returns true" do
      Authentise::API::Warehouse.stub :put_file, true do
        model.send_file.must_equal true
      end
    end
  end

  describe "#fetch" do
    it "calls the API and sets what is returned" do
      api_return = {
        name: "Test 2",
        status: "error",
        snapshot: "http://snapshot",
        content: "http://content",
        manifold: true,
        created_at: Time.local(2015, 1, 1),
        updated_at: Time.local(2015, 1, 2),
        parents: ["http://parent1", "http://parent2"],
        children: ["http://child1"],
      }
      Authentise::API::Warehouse.stub :get_model, api_return do
        model.fetch(session_token: "f56").must_equal true
        model.name.must_equal api_return[:name]
        model.status.must_equal api_return[:status]
        model.snapshot.must_equal api_return[:snapshot]
        model.content.must_equal api_return[:content]
        model.manifold.must_equal api_return[:manifold]
        model.created_at.must_equal api_return[:created_at]
        model.updated_at.must_equal api_return[:updated_at]
        model.parents.must_equal api_return[:parents]
        model.children.must_equal api_return[:children]
      end
    end
  end

  describe "#find_by_url" do
    it "finds a model" do
      api_return = {
        name: "Test 2",
        status: "error",
        snapshot: "http://snapshot",
        content: "http://content",
        manifold: true,
        created_at: Time.local(2015, 1, 1),
        updated_at: Time.local(2015, 1, 2),
        parents: ["http://parent1", "http://parent2"],
        children: ["http://child1"],
      }
      Authentise::API::Warehouse.stub :get_model, api_return do
        model = Authentise::Model.find_by_url(url: "http://meh",
                                              session_token: "f42")
        model.url.must_equal "http://meh"
        model.name.must_equal api_return[:name]
        model.status.must_equal api_return[:status]
        model.snapshot.must_equal api_return[:snapshot]
        model.content.must_equal api_return[:content]
        model.manifold.must_equal api_return[:manifold]
        model.created_at.must_equal api_return[:created_at]
        model.updated_at.must_equal api_return[:updated_at]
        model.parents.must_equal api_return[:parents]
        model.children.must_equal api_return[:children]
      end
    end
  end
end
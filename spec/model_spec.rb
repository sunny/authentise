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
        snapshot_url: "http://snapshot",
        content_url: "http://content",
        manifold: true,
        created_at: Time.local(2015, 1, 1),
        updated_at: Time.local(2015, 1, 2),
        parents_urls: ["http://parent1", "http://parent2"],
        children_urls: ["http://child1"],
      }
      Authentise::API::Warehouse.stub :get_model, api_return do
        model.fetch(session_token: "f56").must_equal true
        model.name.must_equal api_return[:name]
        model.status.must_equal api_return[:status]
        model.snapshot_url.must_equal api_return[:snapshot_url]
        model.content_url.must_equal api_return[:content_url]
        model.manifold.must_equal api_return[:manifold]
        model.created_at.must_equal api_return[:created_at]
        model.updated_at.must_equal api_return[:updated_at]
        model.parents_urls.must_equal api_return[:parents_urls]
        model.children_urls.must_equal api_return[:children_urls]
      end
    end
  end

  describe "#find_by_url" do
    it "finds a model" do
      api_return = {
        url: "http://model/4242",
        uuid: "4242",
        name: "Test 2",
        status: "error",
        snapshot_url: "http://snapshot",
        content_url: "http://content",
        manifold: true,
        created_at: Time.local(2015, 1, 1),
        updated_at: Time.local(2015, 1, 2),
        parents_urls: ["http://parent1", "http://parent2"],
        children_urls: ["http://child1"],
      }
      Authentise::API::Warehouse.stub :get_model, api_return do
        model = Authentise::Model.find_by_url(url: "http://model/4242",
                                              session_token: "f42")
        model.url.must_equal api_return[:url]
        model.uuid.must_equal api_return[:uuid]
        model.name.must_equal api_return[:name]
        model.status.must_equal api_return[:status]
        model.snapshot_url.must_equal api_return[:snapshot_url]
        model.content_url.must_equal api_return[:content_url]
        model.manifold.must_equal api_return[:manifold]
        model.created_at.must_equal api_return[:created_at]
        model.updated_at.must_equal api_return[:updated_at]
        model.parents_urls.must_equal api_return[:parents_urls]
        model.children_urls.must_equal api_return[:children_urls]
      end
    end
  end

  describe "#find_by_uuid" do
    it "finds a model" do
      api_return = {
        url: "http://model/4242",
        uuid: "4242",
        name: "Test 2",
        status: "error",
        snapshot_url: "http://snapshot",
        content_url: "http://content",
        manifold: true,
        created_at: Time.local(2015, 1, 1),
        updated_at: Time.local(2015, 1, 2),
        parents_urls: ["http://parent1", "http://parent2"],
        children_urls: ["http://child1"],
      }
      Authentise::API::Warehouse.stub :get_model, api_return do
        model = Authentise::Model.find_by_uuid(uuid: "4242",
                                              session_token: "f42")
        model.url.must_equal api_return[:url]
        model.uuid.must_equal api_return[:uuid]
        model.name.must_equal api_return[:name]
        model.status.must_equal api_return[:status]
        model.snapshot_url.must_equal api_return[:snapshot_url]
        model.content_url.must_equal api_return[:content_url]
        model.manifold.must_equal api_return[:manifold]
        model.created_at.must_equal api_return[:created_at]
        model.updated_at.must_equal api_return[:updated_at]
        model.parents_urls.must_equal api_return[:parents_urls]
        model.children_urls.must_equal api_return[:children_urls]
      end
    end
  end
end

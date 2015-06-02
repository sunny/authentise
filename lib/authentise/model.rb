require "authentise/api/warehouse"

module Authentise
  # Represents a model in the Model Warehouse
  class Model
    attr_accessor :name, # Required

                  # Available only when model is created or fetched
                  :url,

                  # Available only when model is created
                  :upload_url,

                  # Available only when model is fetched
                  :status,
                  :snapshot_url,
                  :content_url,
                  :manifold,
                  :created_at,
                  :updated_at,
                  :parents_urls,
                  :children_urls,

                  # You can initialize a model with it but it is not available
                  # when fetched
                  :uuid


    def initialize(name: nil,
                   url: nil,
                   upload_url: nil,
                   uuid: nil)
      @name = name
      @upload_url = upload_url
      @url = url
      @uuid = uuid
    end

    def create(session_token: nil)
      response = API::Warehouse.create_model(
        session_token: session_token,
        name: name
      )
      @upload_url = response[:upload_url]
      @url = response[:model_url]
      true
    end

    def send_file(path: nil)
      API::Warehouse.put_file(
        url: upload_url,
        path: path
      )
    end

    def fetch(session_token: nil)
      response = API::Warehouse.get_model(uuid: uuid,
                                          url: url,
                                          session_token: session_token)
      @url = response[:url]
      @uuid = response[:uuid]
      @name = response[:name]
      @status = response[:status]
      @snapshot_url = response[:snapshot_url]
      @content_url = response[:content_url]
      @manifold = response[:manifold]
      @parents_urls = response[:parents_urls]
      @children_urls = response[:children_urls]
      @created_at = response[:created_at]
      @updated_at = response[:updated_at]
      true
    end

    def self.find_by_url(url: url, session_token: nil)
      model = new(url: url)
      model.fetch(session_token: session_token)
      model
    end

    def self.find_by_uuid(uuid: uuid, session_token: nil)
      model = new(uuid: uuid)
      model.fetch(session_token: session_token)
      model
    end
  end
end

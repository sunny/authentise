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
                  :snapshot,
                  :content,
                  :manifold,
                  :created_at,
                  :updated_at,
                  :parents,
                  :children


    def initialize(name: nil,
                   url: nil,
                   upload_url: nil)
      @name = name
      @upload_url = upload_url
      @url = url
    end

    def create(session_token: nil)
      response = API::Warehouse.create_model(
        session_token: session_token,
        name: name
      )
      @upload_url = response[:upload_url]
      @url = response[:model_url]
    end

    def send_file(path: nil)
      API::Warehouse.put_file(
        url: upload_url,
        path: path
      )
    end

    def self.find_by_url(url)
      response = API::Warehouse.get_model(url)

      model = new
      model.name = response[:name]
      model.status = response[:status]
      model.snapshot = response[:snapshot]
      model.content = response[:content]
      model.manifold = response[:manifold]
      model.created_at = response[:created_at]
      model.updated_at = response[:updated_at]
      model.parents = response[:parents]
      model.children = response[:children]
      model
    end
  end
end

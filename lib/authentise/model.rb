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
      true
    end

    def send_file(path: nil)
      API::Warehouse.put_file(
        url: upload_url,
        path: path
      )
    end

    def fetch(session_token: nil)
      response = API::Warehouse.get_model(url: url,
                                          session_token: session_token)
      self.name = response[:name]
      self.status = response[:status]
      self.snapshot = response[:snapshot]
      self.content = response[:content]
      self.manifold = response[:manifold]
      self.created_at = response[:created_at]
      self.updated_at = response[:updated_at]
      self.parents = response[:parents]
      self.children = response[:children]
      true
    end

    def self.find_by_url(url: url, session_token: nil)
      model = new(url: url)
      model.fetch(session_token: session_token)
      model
    end
  end
end

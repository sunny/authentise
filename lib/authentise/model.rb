require "authentise/api/warehouse"

module Authentise
  # Represents a model in the Model Warehouse
  class Model
    attr_reader :name,
                :url,
                :upload_url

    def initialize(name: nil,
                   url: nil,
                   upload_url: nil)
      # Required
      @name = name

      # Included when model is created
      @url = url
      @upload_url = upload_url
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
  end
end

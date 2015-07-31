require "authentise/api"

module Authentise
  module API
    # Upload models and take snapshot pictures
    module Warehouse
      module_function

      # Params:
      # - cookie
      #
      # - name (string) – Required. The name of the model. This can be any
      #   string and should be meaningful to the user
      #
      # - allowed_transformations (hash) – Optional. The transformations that
      #   are allowed on this model.
      #   * resize (boolean) – Optional. true if this
      #     model is allowed to be resized automatically by other services.
      #     Default: false.
      #   * rotation (boolean) – Optional. true if
      #     this model is allowed to be rotated automatically by other services.
      #     Default: false.
      #
      # - callback (hash) – Optional. The URL to call when this model changes
      #   states.
      #   * url (string) – Optional. The URL to request for the
      #     callback
      #   * method (string) – Optional. The method to use for the
      #     request, one of GET, POST or PUT.
      def create_model(session_token: nil, name: nil)
        url = "https://models.authentise.com/model/"
        body = {
          name: name,
        }.to_json
        options = {
          content_type: :json,
          accept: :json,
          cookies: { session: session_token },
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.post(url, body, options) do |response, _request, _result|
          if response.code == 201
            {
              model_url: response.headers[:location],
              upload_url: response.headers[:x_upload_location],
            }
          else
            fail API::Error, JSON.parse(response)["message"]
          end
        end
      end

      def put_file(url: nil, path: nil)
        file = File.read(path)
        options = {
          content_type: 'application/octet-stream',
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.put(url, file, options) do |response, _request, _result|
          if response.code == 200
            true
          else
            fail API::Error, response
          end
        end
      end

      # Get information about a model from its URL or UUID.
      def get_model(url: nil, uuid: nil, session_token: nil)
        url ||= "https://models.authentise.com/model/#{uuid}/"
        headers = {
          content_type: :json,
          accept: :json,
          cookies: { session: session_token },
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.get(url, headers) do |response, _request, _result|
          if response.code == 200
            parse_model(response, url)
          elsif response.code == 404
            fail Authentise::API::NotFoundError
          else
            fail Authentise::API::Error, "Error #{response.code}"
          end
        end
      end


      # # Get a list of all models the requester has access to based on
      # # query filters.
      # #
      # # Params:
      # # - session_token
      # # - name: a partial name of models to search for. accepts the
      # #   wildcard character: “*”.
      # # - status: a status of models to search for.
      # # - created: a creation date to search for models.
      # # - updated: a updated date to search for models.
      # # - sort – one of the other queryable parameters, such as name,
      # #   status, created or updated. accepts + or - to indicate order of
      # #   the sort. parameters may be strung together, separated by commas.
      # #   example: "+status, +created, -name" or "name, created"
      # def get_models(params = {})
      #   query = params.dup
      #   session_token = query.delete(:session_token)

      #   url = "https://models.authentise.com/model/"
      #   options = {
      #     params: query,
      #     content_type: :json,
      #     accept: :json,
      #     cookies: { session: session_token }
      #   }

      #   RestClient.get(url, options) do |response, request, result|
      #     if response.code == 200
      #       data = JSON.parse(response)
      #       p data
      #       {
      #         # ?
      #         models: data["models"]
      #       }
      #     else
      #       raise Authentise::API::Error, "Error #{response.code}"
      #     end
      #   end
      # end


      # Create a model snapshot.
      #
      # Required arguments:
      # - session_token: for authentication.
      # - model_uuid: which model to create a snapshot for.
      #
      # Optional arguments:
      # - samples (int) – The number of samples to use in requesting the
      #                 snapshot. Min 0, Max 5000. Higher numbers will take
      #                 konger but yield better-looking results
      # - layer (int) – The number of the layer of the model to show. This
      #                 allows you to visualize the model when partially printed
      # - color (string) – The color, in HTML color codes, to use for the
      #                    material the model is made of. Ex: #AFAA75
      # - height (int) – The height of the image in pixels. Min 0, Max 768
      # - width (int) – The width oft he image in pixels. Min 0, Max 1024
      # - x (float) – The position of the camera on the X axis
      # - y (float) – The position of the camera on the Y axis
      # - z (float) – The position of the camera on the Z axis
      # - u (float) – The camera direction vector’s X component
      # - v (float) – The camera direction vector’s Y component
      # - w (float) – The camera direction vector’s Z component
      # - callback (hash):
      #   * url (string) – The url to callback to once model processing is
      #                    finished.
      #   * method (string) – The http method for the callback to use when
      #                       calling back.
      def create_snapshot(arguments = {})
        params = arguments.dup
        session_token = params.delete(:session_token)
        model_uuid = params.delete(:model_uuid)

        url = "https://models.authentise.com/model/#{model_uuid}/snapshot/"
        body = params.to_json
        headers = {
          content_type: :json,
          accept: :json,
          cookies: { session: session_token },
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.post(url, body, headers) do |response, _request, _result|
          if response.code == 201
            {
              url: response.headers[:location],
            }
          else
            fail API::Error, JSON.parse(response)["message"]
          end
        end
      end


      # Get information about a snapshot from its URL.
      def get_snapshot(url: nil, session_token: nil)
        headers = {
          content_type: :json,
          accept: :json,
          cookies: { session: session_token },
          open_timeout: 2,
          timeout: 2,
        }
        RestClient.get(url, headers) do |response, _request, _result|
          if response.code == 200
            parse_snapshot(response)
          elsif response.code == 404
            fail Authentise::API::NotFoundError
          else
            fail Authentise::API::Error, "Error #{response.code}"
          end
        end
      end


      def parse_model(response, url)
        data = JSON.parse(response)
        {
          # URL to fetch this model
          url: url,
          # Identifier for the model
          uuid: url.split("/").last,
          # The name of the model. (string)
          name: data["name"],
          # The current status of the model processing. Can be one of
          # "processing", "processed", or "error".
          status: data["status"],
          # Link at which a snapshot of the model can be downloaded.
          snapshot_url: data["snapshot"],
          # Link at which a the model can be downloaded.
          content_url: data["content"],
          # Boolean represeting if the model is manifold. If the model is
          # not manifold, there is a higher likelyhood that slicing will
          # fail.
          manifold: data["analyses.manifold"],
          # The date and time the model was created.
          created_at: parse_time(data["created"]),
          # The date and time the model was last updated.
          updated_at: parse_time(data["updated"]),
          # An array of model uris from which this model is derived.
          parents_urls: data["parents"],
          #  An array of model uris from which are derived from this model.
          children_urls: data["children"],
        }
      end
      private_class_method :parse_model

      # rubocop:disable Metrics/AbcSize
      def parse_snapshot(response)
        data = JSON.parse(response)
        {
          status: "snapshot_rendering",
          samples: data["samples"],
          layer: data["layer"],
          color: data["color"],
          height: data["height"],
          width: data["width"],
          x: data["x"],
          y: data["y"],
          z: data["z"],
          u: data["u"],
          v: data["v"],
          w: data["w"],
          slice_height: data["slice_height"],
          created_at: parse_time(data["created"]),
          content_url: data["content"],
        }
      end
      # rubocop:enable Metrics/AbcSize

      def parse_time(string)
        string && Time.parse(string)
      end
      private_class_method :parse_time
    end
  end
end

require "authentise/api/print"

module Authentise
  # Represents a streaming print iframe request
  class Print
    attr_accessor :model_url,
                  :receiver_email,
                  :print_value,
                  :print_value_currency,
                  :partner_job_id

    def initialize(model_url: nil,
                   receiver_email: nil,
                   print_value: nil,
                   print_value_currency: nil,
                   partner_job_id: nil)
      @model_url = model_url
      @receiver_email = receiver_email
      @print_value = print_value
      @print_value_currency = print_value_currency
      @partner_job_id = partner_job_id
    end

    def url
      @url ||= begin
        response = API::Print.create_token(
          model_url: model_url,
          receiver_email: receiver_email,
          print_value: print_value,
          print_value_currency: print_value_currency,
          partner_job_id: partner_job_id,
        )
        response[:url]
      end
    end
  end
end

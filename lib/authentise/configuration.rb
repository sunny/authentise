# Configure your application using this construct:
#
#   Authentise.configure do |c|
#     c.secret_partner_key = "…"
#   end
module Authentise
  # Store the config
  class Configuration
    # The partner key Authentise gave you
    attr_accessor :secret_partner_key

    # DEPRECATED
    # Switch off the use of SSL for the old streaming API
    attr_accessor :use_ssl

    def initialize
      @use_ssl = true
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

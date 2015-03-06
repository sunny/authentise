module Authentise
  class Configuration
    attr_accessor :secret_partner_key
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

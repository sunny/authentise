require "minitest/autorun"
require "webmock/minitest"

require "authentise"

Authentise.configure do |c|
  c.secret_partner_key = "test"
end

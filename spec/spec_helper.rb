require "minitest/autorun"
require "webmock/minitest"

require "authentize"

Authentize.configure do |c|
  c.secret_partner_key = "test"
end

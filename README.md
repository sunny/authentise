Ruby gem to access Authentize API v3
====================================

See http://docs.dev-auth.com/

Ye be warned: this has not been tested whatsoever.

Example usage
-------------

```rb
require "authentize"

Authentize.configure do |c|
  c.secret_partner_key = "ZSBzaG9y-dCB2ZWhl-bWVuY2Ug-b2YgYW55-IGNhcm5h-bCB=="
end

Authentize::API.create_token
# => "33b41d6e80d4918cfff768185d1d31a6"

Authentize::API.upload_file(file: File.open("example.stl"),
                            token: "33b41d6e80d4918cfff768185d1d31a6",
                            email: "example@example.com",
                            cents: 2_00,
                            currency: "EUR")
# => "https://widget.sendshapes.com/?token=33b41d6e80d4918cfff768185d1d31a6"
```

Ruby gem to access Authentise API v3
====================================

See http://docs.authentise.com/model/reference.html

Example usage
-------------

```rb
Authentise.configure do |c|
  c.secret_partner_key = "ZSBzaG9y-dCB2ZWhl-bWVuY2Ug-b2YgYW55-IGNhcm5h-bCB=="
  c.use_ssl = false
end

upload = Authentise::Upload.new(
  stl_file: File.new("example.stl", "rb"),
  email: "example@example.com",
  cents: 2_00,
  currency: "EUR"
)

upload.token
# => "33b41d6e80d4918cfff768185d1d31a6"

upload.link_url
# => "https://widget.sendshapes.com/?token=33b41d6e80d4918cfff768185d1d31a6"

upload.status
# => {
#  printing_job_status_name: "warming_up",
#  printing_percentage: 0,
#  minutes_left: 21,
#  message: ""
# }
```

Install
-------

Add the following line to your Gemfile:

```rb
gem "authentise"
```


Development
-----------

For local development, please install the `bundler` gem then:

```sh
$ bundle
```

To launch specs:

```sh
$ rake
```

List other tasks:

```sh
$ rake -T
```

License
-------

Created by Sunny Ripert for [Cults.](https://cults3d.com),
licensed under the MIT License.

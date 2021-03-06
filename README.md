Ruby gem to access Authentise API v3
====================================

See http://docs.authentise.com/model/reference.html

Install
-------

Add the following lines to your Gemfile:

```rb
# Stream 3D files through Authentise's API
gem "authentise"
```


Configuration
-------------

Set your secret partner key:

```rb
Authentise.configure do |c|
  c.secret_partner_key = "ZSBzaG9y-dCB2ZWhl-bWVuY2Ug-b2YgYW55-IGNhcm5h-bCB=="
end
```

Usage
------

### Authentication

```rb
# Create a user
user = Authentise::User.new(
  email: 'you@example.com',
  name: 'You',
  username: 'you',
  password: 'p4ssw0rd;99'
)
user.create

# Create a session
session = Authentise::Session.new(
  username: 'you',
  password: 'p4ssw0rd;99'
)
session.create
```

### Model Warehouse

```rb
# Create a model
model = Authentise::Model.new(name: "My model")
model.create(session_token: session.token)
model.send_file(path: 'example.stl')
model.url # => "https://models.authentise.com/model/42424…"

# Get a model
model = Authentise::Model.find_by_url(
  url: "https://models.authentise.com/model/42424…",
  session_token: session.token
)
model.name # => "My model"
model.status # => "processing"
model.content_url # => ""https://prod-hoth-models.s3.amazonaws.com:443/07c74a…"
```

### Streaming iframe

```rb
# Create a print
print = Authentise::Print.new(
  model_url: "https://models.authentise.com/model/42424…"
)

# Show an iframe to this URL to the user
print.url
# => "https://widget.sendshapes.com/?token=33b41d6e80d4918cfff768185d1d31a6"


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

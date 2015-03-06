$:.push File.expand_path("../lib", __FILE__)

require "authentise/version"

Gem::Specification.new do |s|
  s.name        = "authentise"
  s.version     = Authentise::VERSION
  s.authors     = ["Sunny Ripert"]
  s.email       = ["sunny@sunfox.org"]
  s.homepage    = "http://github.com/sunny/authentise"
  s.summary     = "Access the Authentise v3 API"
  s.description = "Access Authentise's 3D-Printing streaming API"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rest-client"

  s.add_development_dependency "webmock"
  s.add_development_dependency "rake"
end

$:.push File.expand_path("../lib", __FILE__)

require "authentize/version"

Gem::Specification.new do |s|
  s.name        = "authentize"
  s.version     = Authentize::VERSION
  s.authors     = ["Sunny Ripert"]
  s.email       = ["sunny@sunfox.org"]
  s.homepage    = "http://github.com/sunny/authentize"
  s.summary     = "Access the Authentize v3 API"
  s.description = "Access Authentize's 3D-Printing streaming API"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rest-client"

  s.add_development_dependency "webmock"
  s.add_development_dependency "rake"
end

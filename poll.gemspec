$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "poll/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "poll"
  s.version     = Poll::VERSION
  s.authors     = ["Chris Blackburn"]
  s.email       = ["chris@madebymade.co.uk"]
  s.homepage    = "http://www.madebymade.co.uk/"
  s.summary     = "Custom form creation"
  s.description = "Build custom polling forms in ActiveAdmin"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "stringex", "~> 1.5.1"

  s.add_development_dependency "sqlite3"
end

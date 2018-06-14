$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "arask/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "arask"
  s.version     = Arask::VERSION
  s.authors     = ["Esben Damgaard"]
  s.email       = ["ebbe@hvemder.dk"]
  s.homepage    = "http://github.com/Ebbe/arask"
  s.summary     = "Automatic RAils taSKs (with minimal setup)"
  s.description = "With minimal setup, be able to regularly run tasks in Rails. Either user cron syntax or simply define an interval."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency "fugit", "~> 1.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end

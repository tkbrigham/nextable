$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nextable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nextable"
  s.date        = '2016-01-21'
  s.version     = Nextable::VERSION
  s.authors     = "Thomas Brigham"
  s.email       = "thomas@thomasbrigham.me"
  s.homepage    =  'http://rubygems.org/gems/nextable'
  s.license     = "MIT"
  s.summary     = "Extends ActiveRecord::Base to implement #next_record and
                     #previous_record instance methods"
  s.description = <<-EOF
 ** NOT PRODUCTION READY ** 
A plugin for Rails that enables 'walking' of ActiveRecord models by implementing
next_record and #previous_record instance methods.
Documentation: https://github.com/tkbrigham/nextable
EOF

  s.files       = ["lib/nextable.rb"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'rails', '~> 4.1', '>= 4.1.14'
  s.add_development_dependency 'sqlite3'
end

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
 Allows "walking" of a table of ActiveRecord records by implementing 
 #next_record and #previous_record.

Options:
- field: [Defaults to 'id'] which field should be used to calculate order. If
  two records have the same value for the specified field, records will be
  sub-ordered by ID.
- cycle: [Defaults to false] upon reaching last (or first) record in order,
  determines whether or not it should return nil or cycle to beginning (or end)
- filters: [Defaults to {}] a hash passed to self.class.where to determine
  scope. This will break if the ActiveRecord object does not have all of the
  keys that are passed into the hash.
EOF

  s.files       = ["lib/nextable.rb"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'rails', '~> 4.1', '>= 4.1.14'
  s.add_development_dependency 'sqlite3'
end

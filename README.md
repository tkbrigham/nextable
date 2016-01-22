# Nextable
**WARNING**: Do Not Use In Production Applications!

A plugin for Rails that enables 'walking' of ActiveRecord models by
 implementing #next_record and #previous_record instance methods.

## Why

Every wanted to simply get surrounding records without pulling in pagination?
Ever want the record with the next highest `hits` attribute? Or wanted the next
record that had the same attribute as your current one? 

You can have it all.

## Examples

Defaults to walking by **ID**
```ruby
3.times do { User.create! }
u1 = User.first
  => #<User id: 1, ...>
bono = u.next_record
  => #<User id: 2, ...>
u3 = bono.next_record
  => #<User id: 3, ...>
u4 = u3.next_record
  => nil
u4 = u3.previous_record
  => #<User id: 2, ...>
u4 == bono
  => true
```

**cycle**: Restart at beginning (or end)
```ruby
u3.next_record(cycle: true)
  => #<User id: 1, ...>
u1.previous_record(cycle: true)
  => #<User id: 3, ...>
u1.previous_record
  => nil
```

**field**: Pass alternate field to determine order
```ruby
[9,8,7].each { |n| User.create!(id: n) }
User.all.order(:created_at).collect(&:id)
  => [9,8,7]
u = User.find(8)
next = u.next_record(field: 'created_at')
  => #<User id: 7, ...>
```

**filters**: Pass filters (as a Hash) to set the scope
```ruby
[9,7].each { |n| User.find(n).update!(name: "Abacus") }
User.find(8).update!(name: "Zenith")
User.all.collect { |u| [u.id, u.name] }
  => [[7, "Fubart"], [8, "Zenith"], [9, "Fubart"]]
u = User.find(7)
  => #<User id: 7, name: "Fubart", ...>
u.next_record(filters: { name: "Fubart" })
  => #<User id: 9, name: "Fubart", ...>
```

## Installation

Simply add the following line in your Gemfile:
`gem 'nextable'`

Then run the following command from your terminal:
`bundle install`

## Run tests

From the folder you want to contain the nextable folder, run:
```
git clone git@github.com:tkbrigham/nextable.git
```
Once that completes:
```
cd nextable
rake
```

## Contribute?

Suggestions welcome: thomas@thomasbrigham.me

## License

MIT

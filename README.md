[![Gem Version](https://badge.fury.io/rb/nextable.svg)](https://badge.fury.io/rb/nextable)

# Nextable
**WARNING**: Do Not Use In Production Applications!

A plugin for Rails that enables 'walking' of ActiveRecord models by
 implementing #next_record and #previous_record instance methods. 

As of 2016-02-19, this plugin has been tested with:
- Postgres 9.5
- MySQL 5.7

## Why

Ever wanted to simply get surrounding records without pulling in pagination?
Or the next record based on number of `hits`? Or the prior record with the same
`name`?

Or all three?

You can have it all.

## Examples

Defaults to walking by **ID**
```ruby
3.times do { User.create! }
u1 = User.first
  #=> #<User id: 1, ...>
bono = u.next_record
  #=> #<User id: 2, ...>
u3 = bono.next_record
  #=> #<User id: 3, ...>
u4 = u3.next_record
  #=> nil
u4 = u3.previous_record
  #=> #<User id: 2, ...>
u4 == bono
  #=> true
```

**cycle**: Restart at beginning (or end)
```ruby
u3.next_record(cycle: true)
  #=> #<User id: 1, ...>
u1.previous_record(cycle: true)
  #=> #<User id: 3, ...>
u1.previous_record
  #=> nil
```

**field**: Pass alternate field to determine order
```ruby
[9,8,7].each { |n| User.create!(id: n) }
User.all.order(:created_at).collect(&:id)
  #=> [9,8,7]
u = User.find(8)
next = u.next_record(field: 'created_at')
  #=> #<User id: 7, ...>
```

**filters**: Pass filters (as a Hash) to set the scope
```ruby
[9,7].each { |n| User.find(n).update!(name: "Abacus") }
User.find(8).update!(name: "Zenith")
User.all.collect { |u| [u.id, u.name] }
  #=> [[7, "Abacus"], [8, "Zenith"], [9, "Abacus"]]
u = User.find(7)
  #=> #<User id: 7, name: "Abacus", ...>
u.next_record(filters: { name: "Abacus" })
  #=> #<User id: 9, name: "Abacus", ...>
```

## Installation

Simply add the following line in your Gemfile:
`gem 'nextable'`

Then run the following command from your terminal:
`bundle install`

#### Uninstall
Navigate to the folder that contains the `nextable` directory and run:
```
rm -Rf nextable
gem uninstall nextable
```

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

## Possible issues

* Flexibility of date, time, and datetime formats (ie "Feb 2, 1990" and
  "1990-2-2" should both work)

## Questions? Contributions?

All are welcome: thomas@thomasbrigham.me

## License

(The MIT License)

Copyright © Thomas Brigham

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

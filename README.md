# Kd-tree

My Ruby implementation of a [Kd-tree](https://en.wikipedia.org/wiki/K-d_tree). Kd-trees allow for fast nearest-neighbor searches. This implementation will also allow the Kd-tree to be cached using ```Rails.cache``` methods. For now, this only supports 2d latitude/longitude searches.

## Getting Started

For starters:

```ruby
gem 'kdtree'
```

## Usage

A Kd-tree is made up of multiple nodes. A single node contains the data associated with the latitude/longitude:

```ruby
Kdtree::LatitudeLongitudeNode.new(your_data_here, latitude_of_your_data, longitude_of_your_data)
```

Once you have an array of nodes, you can create a Kd-tree:
```ruby
nodes = [Kdtree::LatitudeLongitudeNode.new(...), Kdtree::LatitudeLongitudeNode.new(...)]
my_tree = Kdtree::LatitudeLongitudeTree.new(nodes)
```

You can query your tree and return the closest nodes:
```ruby
# The 4th parameter may be :miles or :kilometers
all_my_nodes = my_tree.closest(my_lat, my_long, distance, :kilometers)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aaronFranssell/kdtree.

Please make sure all tests pass and that [Rubocop](https://github.com/bbatsov/rubocop) is happy:
```ruby
rake test
rubocop -Dac .rubocop.yml
```



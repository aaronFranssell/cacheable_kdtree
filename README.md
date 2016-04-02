[![Build Status](https://travis-ci.org/aaronFranssell/cacheable_kdtree.svg?branch=master)](https://travis-ci.org/aaronFranssell/cacheable_kdtree)
[![Code Climate](https://codeclimate.com/github/aaronFranssell/cacheable_kdtree/badges/gpa.svg)](https://codeclimate.com/github/aaronFranssell/cacheable_kdtree)
[![Test Coverage](https://codeclimate.com/github/aaronFranssell/cacheable_kdtree/badges/coverage.svg)](https://codeclimate.com/github/aaronFranssell/cacheable_kdtree/coverage)

# Kd-tree

My Ruby implementation of a [Kd-tree](https://en.wikipedia.org/wiki/K-d_tree). Kd-trees allow for fast nearest-neighbor searches. This implementation will also allow the Kd-tree to be cached using ```Rails.cache``` methods. For now, this only supports 2d latitude/longitude searches.

## Getting Started

Add the gem:

```ruby
gem 'cacheable_kdtree'
```

## Usage

A Kd-tree is made up of multiple nodes. A single node contains the data associated with the latitude/longitude:

```ruby
CacheableKdtree::LatitudeLongitudeNode.new(your_data_here, latitude_of_your_data, longitude_of_your_data)
```

Once you have an array of nodes, you can create a Kd-tree:
```ruby
nodes = [CacheableKdtree::LatitudeLongitudeNode.new(...), CacheableKdtree::LatitudeLongitudeNode.new(...)]
my_tree = CacheableKdtree::LatitudeLongitudeTree.new(nodes)
```

You can query your tree and return the closest nodes:
```ruby
# The 4th parameter may be :miles or :kilometers
all_my_nodes = my_tree.closest(my_lat, my_long, distance, :kilometers)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aaronFranssell/cacheable_kdtree.

Please make sure all tests pass and that [Rubocop](https://github.com/bbatsov/rubocop) is happy:
```ruby
rake test
rubocop -Dac .rubocop.yml
```



%w(
  version
  latitude_longitude_node
  latitude_longitude_region
  latitude_longitude_tree
  util
).each { |name| require "cacheable_kdtree/#{name}" }

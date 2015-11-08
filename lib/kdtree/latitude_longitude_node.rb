class Kdtree::LatitudeLongitudeNode
  attr_accessor :left, :right, :data, :latitude, :longitude, :depth, :region

  def initialize(node_data, node_lat, node_long)
    @data = node_data
    @latitude = node_lat
    @longitude = node_long
  end

  def compare_value
    self.class.use_latitude?(depth) ? latitude : longitude
  end

  def branch(other_node)
    use_right_child?(other_node) ? right : left
  end

  def assign_branch(other_node)
    if use_right_child?(other_node)
      @right = other_node
    else
      @left = other_node
    end
    other_node.depth = depth + 1
    other_node
  end

  def to_s
    "region: #{region ? region.to_s : region}"
  end

  def self.create_or_merge_regions(n1, n2)
    return Kdtree::LatitudeLongitudeRegion.new(n1.latitude, n1.longitude, n2.latitude, n2.longitude) if n1.region.nil? && n2.region.nil?
    return n1.region.merge_point(n2.latitude, n2.longitude) if n1.region && n2.region.nil?
    return n2.region.merge_point(n1.latitude, n1.longitude) if n2.region && n1.region.nil?
    n1.region.merge_region(n2.region)
  end

  def self.sort_node_list(node_list, depth)
    use_latitude?(depth) ? node_list.sort_by(&:latitude) : node_list.sort_by(&:longitude)
  end

  def self.partition_node_list(node_list)
    midpoint = node_list.length / 2
    [node_list.slice(0, node_list.length / 2), node_list[midpoint], node_list.slice(midpoint + 1..-1)]
  end

  def self.use_latitude?(depth)
    depth.even?
  end

  private

  def use_right_child?(other_node)
    other_node.compare_value > compare_value
  end
end

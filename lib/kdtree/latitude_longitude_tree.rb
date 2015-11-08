class Kdtree::LatitudeLongitudeTree
  attr_accessor :root, :length

  def initialize(node_list)
    @length = node_list.length
    @root = create_tree(node_list)
    find_regions(@root)
  end

  def closest(lat, long, distance, units = :miles)
    fail 'Input must be numeric.' unless lat.is_a?(Numeric) && long.is_a?(Numeric) && distance.is_a?(Numeric)
    fail 'Units must be either :kilometers or :miles.' unless %i(miles kilometers).include?(units)
    bounding_box = units == :miles ? Kdtree::Util.bounding_box_miles(lat, long, distance) : Kdtree::Util.bounding_box_kilometers(lat, long, distance)
    nearest_nodes(bounding_box)
  end

  private

  def nearest_nodes(bounding_box, node = @root, result = [])
    return result if node.nil?
    if node.data.locator_address.zip.start_with?('59')
      puts ''
      puts 'BOUNDING_BOX'
      puts bounding_box.inspect
      puts 'NODE'
      puts "#{node.latitude}, #{node.longitude}"
      puts 'bounding_box.point_in_region?(node.latitude, node.longitude)'
      puts bounding_box.point_in_region?(node.latitude, node.longitude)
      log_children(node, bounding_box)
    end
    result << node if bounding_box.point_in_region?(node.latitude, node.longitude)
    nearest_nodes(bounding_box, node.left, result) if search_child?(node.left, bounding_box)
    nearest_nodes(bounding_box, node.right, result) if search_child?(node.right, bounding_box)
    result
  end

  def log_children(node, bounding_box)
    return unless node && node.region
    puts node.region.to_s
    if node.left && node.left.region
      puts 'LEFT CHILD'
      puts node.left.to_s
      puts 'SEARCH CHILD?'
      puts search_child?(node.left, bounding_box)
    end
    if node.right && node.right.region
      puts 'right CHILD'
      puts node.right.to_s
      puts 'SEARCH CHILD?'
      puts search_child?(node.right, bounding_box)
    end
  end

  def search_child?(child, bounding_box)
    child &&
      (bounding_box.point_in_region?(child.latitude, child.longitude) ||
      (child.region && Kdtree::LatitudeLongitudeRegion.regions_intersect?(child.region, bounding_box)))
  end

  def find_regions(node)
    return unless node
    left_region = find_regions(node.left)
    left_region = Kdtree::LatitudeLongitudeNode.create_or_merge_regions(node, node.left) if node.left
    right_region = find_regions(node.right)
    right_region = Kdtree::LatitudeLongitudeNode.create_or_merge_regions(node, node.right) if node.right
    node.region = merge_regions(left_region, right_region)
    node.region
  end

  def merge_regions(region1, region2)
    return region1 unless region2
    return region2 unless region1
    region1.merge_region(region2)
  end

  def create_tree(node_list, depth = 0)
    return unless node_list.length > 0
    if node_list.length == 1
      return node_list.first
    else
      sorted_list = Kdtree::LatitudeLongitudeNode.sort_node_list(node_list, depth)
      lower_half, midpoint, greater_half = Kdtree::LatitudeLongitudeNode.partition_node_list(sorted_list)
      midpoint.left = create_tree(lower_half, depth + 1)
      midpoint.right = create_tree(greater_half, depth + 1)
      return midpoint
    end
  end
end

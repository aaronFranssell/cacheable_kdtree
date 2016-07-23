class CacheableKdtree::LatitudeLongitudeTree
  attr_accessor :root

  def initialize(node_list)
    @root = create_tree(node_list)
    find_regions(@root)
  end

  def closest(lat, long, distance, units = :miles)
    fail 'Input must be numeric.' unless lat.is_a?(Numeric) && long.is_a?(Numeric) && distance.is_a?(Numeric)
    fail 'Units must be either :kilometers or :miles.' unless %i(miles kilometers).include?(units)
    bounding_box = if units == :miles
                     CacheableKdtree::Util.bounding_box_miles(lat, long, distance)
                   else
                     CacheableKdtree::Util.bounding_box_kilometers(lat, long, distance)
                   end
    nearest_nodes(bounding_box)
  end

  private

  def nearest_nodes(bounding_box, node = @root, result = [])
    return result if node.nil?
    result << node if bounding_box.point_in_region?(node.latitude, node.longitude)
    nearest_nodes(bounding_box, node.left, result) if search_child?(node.left, bounding_box)
    nearest_nodes(bounding_box, node.right, result) if search_child?(node.right, bounding_box)
    result
  end

  def search_child?(child, bounding_box)
    child &&
      (bounding_box.point_in_region?(child.latitude, child.longitude) ||
      (child.region && CacheableKdtree::LatitudeLongitudeRegion.regions_intersect?(child.region, bounding_box)))
  end

  def find_regions(node)
    return unless node
    left_region = find_regions(node.left)
    left_region = CacheableKdtree::LatitudeLongitudeNode.create_or_merge_regions(node, node.left) if node.left
    right_region = find_regions(node.right)
    right_region = CacheableKdtree::LatitudeLongitudeNode.create_or_merge_regions(node, node.right) if node.right
    node.region = merge_regions(left_region, right_region)
    node.region
  end

  def merge_regions(region1, region2)
    return region1 unless region2
    return region2 unless region1
    region1.merge_region(region2)
  end

  def create_tree(node_list, depth = 0)
    return if node_list.empty?
    return node_list.first if node_list.length == 1
    sorted_list = CacheableKdtree::LatitudeLongitudeNode.sort_node_list(node_list, depth)
    lower_half, midpoint, greater_half = CacheableKdtree::LatitudeLongitudeNode.partition_node_list(sorted_list)
    midpoint.left = create_tree(lower_half, depth + 1)
    midpoint.right = create_tree(greater_half, depth + 1)
    midpoint
  end
end

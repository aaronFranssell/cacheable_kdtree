require 'test_helper'

class Kdtree::LatitudeLongitudeNodeTest < Minitest::Test
  describe 'compare_value' do
    before do
      @class_under_test = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
    end

    it 'returns the latitude if the depth is even' do
      @class_under_test.depth = 2

      assert_equal 3, @class_under_test.compare_value
    end

    it 'returns the longitude if the depth is odd' do
      @class_under_test.depth = 3

      assert_equal 5, @class_under_test.compare_value
    end
  end

  describe 'branch' do
    before do
      @curr_node = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      @curr_node.left = 'left'
      @curr_node.right = 'right'
      @curr_node.depth = 2
    end

    it 'should return the right side if the compare value of the other node is greater than the value of this node' do
      other = Kdtree::LatitudeLongitudeNode.new('test', 5, 3)
      other.depth = 2

      assert_equal 'right', @curr_node.branch(other)
    end

    it 'should return the left side if the compare value of the other node is less than the value of this node' do
      other = Kdtree::LatitudeLongitudeNode.new('test', 1, 3)
      other.depth = 2

      assert_equal 'left', @curr_node.branch(other)
    end
  end

  describe 'create_or_merge_regions' do
    it 'creates a region if there is no region present in either node' do
      n1 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n2 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      Kdtree::LatitudeLongitudeRegion.expects(:new).returns 'region'

      result = Kdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end

    it 'merges a point if there is no region on the left node' do
      mock_region = mock
      mock_region.expects(:merge_point).returns 'region'
      n1 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n1.region = mock_region
      n2 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)

      result = Kdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end

    it 'merges a point if there is no region on the right node' do
      n1 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n2 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      mock_region = mock
      mock_region.expects(:merge_point).returns 'region'
      n2.region = mock_region

      result = Kdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end

    it 'merges the regions if both are present' do
      mock_region = mock
      mock_region.expects(:merge_region).returns 'region'
      n1 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n1.region = mock_region
      n2 = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n2.region = mock

      result = Kdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end
  end

  describe 'assign_branch' do
    before do
      @curr_node = Kdtree::LatitudeLongitudeNode.new('test', 3, 5)
      @curr_node.depth = 3
    end

    it 'should assign the other node to the right if the other node is greater than the value of this node' do
      other = Kdtree::LatitudeLongitudeNode.new('test', 1, 7)
      other.depth = 3

      @curr_node.assign_branch(other)

      assert_equal other, @curr_node.right
      assert_equal 4, other.depth
    end

    it 'should assign the other node to the left if the other node is less than the value of this node' do
      other = Kdtree::LatitudeLongitudeNode.new('test', 1, 1)
      other.depth = 3

      @curr_node.assign_branch(other)

      assert_equal other, @curr_node.left
      assert_equal 4, other.depth
    end
  end
end

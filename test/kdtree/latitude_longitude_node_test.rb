require 'test_helper'

class Kdtree::LatitudeLongitudeNodeTest < Minitest::Test
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
end

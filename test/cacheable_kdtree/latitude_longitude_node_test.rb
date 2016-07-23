require 'test_helper'

class CacheableKdtree::LatitudeLongitudeNodeTest < Minitest::Test
  describe 'create_or_merge_regions' do
    it 'creates a region if there is no region present in either node' do
      n1 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n2 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      CacheableKdtree::LatitudeLongitudeRegion.expects(:new).returns 'region'

      result = CacheableKdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end

    it 'merges a point if there is no region on the left node' do
      mock_region = mock
      mock_region.expects(:merge_point).returns 'region'
      n1 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n1.region = mock_region
      n2 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)

      result = CacheableKdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end

    it 'merges a point if there is no region on the right node' do
      n1 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n2 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      mock_region = mock
      mock_region.expects(:merge_point).returns 'region'
      n2.region = mock_region

      result = CacheableKdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end

    it 'merges the regions if both are present' do
      mock_region = mock
      mock_region.expects(:merge_region).returns 'region'
      n1 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n1.region = mock_region
      n2 = CacheableKdtree::LatitudeLongitudeNode.new('test', 3, 5)
      n2.region = mock

      result = CacheableKdtree::LatitudeLongitudeNode.create_or_merge_regions(n1, n2)

      assert_equal 'region', result
    end
  end

  describe 'sort_by_distance_between' do
    before do
      @node_list = []
      @node_list << CacheableKdtree::LatitudeLongitudeNode.new('Beijing', 39.9375346, 115.837023)
      @node_list << CacheableKdtree::LatitudeLongitudeNode.new('Juneau Alaska', 58.3795684, -135.2974705)
      @node_list << CacheableKdtree::LatitudeLongitudeNode.new('White House', 38.8976094, -77.0389236)
      @node_list << CacheableKdtree::LatitudeLongitudeNode.new('Staples Center', 34.0430175, -118.2694428)
      @node_list << CacheableKdtree::LatitudeLongitudeNode.new('Boca Raton', 26.3728125, -80.1883567)
      @node_list.shuffle!
    end

    it 'sorts the list by the distance between the latitude and longitude' do
      lat = 38.8807927
      long = -77.172196 # Arlington, VA
      result = CacheableKdtree::LatitudeLongitudeNode.sort_by_distance_between(lat, long, @node_list)

      ['White House', 'Boca Raton', 'Staples Center', 'Juneau Alaska', 'Beijing'].each_with_index do |expected_data, i|
        assert_equal result[i].data, expected_data
      end
    end
  end
end

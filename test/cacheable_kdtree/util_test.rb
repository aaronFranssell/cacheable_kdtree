require 'test_helper'

class CacheableKdtree::UtilTest < Minitest::Test
  describe 'bounding_box_miles' do
    it 'should create the bounding box in the correct units with the correct distance' do
      lat = 38.890927
      long = -77.086707

      result = CacheableKdtree::Util.bounding_box_miles(lat, long, 250)

      assert_in_delta 42.509221, result.max_latitude, 0.000003
      assert_in_delta(-72.437989, result.max_longitude, 0.000003)
      assert_in_delta 35.272632, result.min_latitude, 0.000003
      assert_in_delta(-81.735424, result.min_longitude, 0.000003)
    end
  end

  describe 'bounding_box_kilometers' do
    it 'should create the bounding box in the correct units with the correct distance' do
      lat = 26.447521
      long = 80.304737

      result = CacheableKdtree::Util.bounding_box_kilometers(lat, long, 0.3)

      assert_in_delta 26.450218, result.max_latitude, 0.000003
      assert_in_delta 80.307750, result.max_longitude, 0.000003
      assert_in_delta 26.444823, result.min_latitude, 0.000003
      assert_in_delta 80.301723, result.min_longitude, 0.000003
    end
  end

  describe 'distance_miles' do
    it 'should calculate the distance in miles' do
      lat1 = 38.8976094
      long1 = -77.0389236 # the white house
      lat2 = 34.0430175
      long2 = -118.2694428 # staples center, where the Lakers play

      result = CacheableKdtree::Util.distance_miles(lat1, long1, lat2, long2)

      assert_in_delta 2295.651157, result, 0.000003
    end
  end

  describe 'distance_kilometers' do
    it 'should calculate the distance in kilometers' do
      lat1 = 26.3728125
      long1 = -80.1883567 # Boca Raton
      lat2 = 58.3795684
      long2 = -135.2974705 # Juneau Alaska

      result = CacheableKdtree::Util.distance_kilometers(lat1, long1, lat2, long2)

      assert_in_delta 5525.037350, result, 0.000003
    end
  end
end

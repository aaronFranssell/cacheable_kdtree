require 'test_helper'

class Kdtree::UtilTest < Minitest::Test
  describe 'bounding_box_miles' do
    it 'should create the bounding box in the correct units with the correct distance' do
      lat = 38.890927
      long = -77.086707

      result = Kdtree::Util.bounding_box_miles(lat, long, 250)
      assert_in_delta 42.508989, result.max_latitude, 0.000003
      assert_in_delta(-72.438281, result.max_longitude, 0.000003)
      assert_in_delta 35.272864, result.min_latitude, 0.000003
      assert_in_delta(-81.735132, result.min_longitude, 0.000003)
    end
  end

  describe 'bounding_box_kilometers' do
    it 'should create the bounding box in the correct units with the correct distance' do
      lat = 26.447521
      long = 80.304737

      result = Kdtree::Util.bounding_box_kilometers(lat, long, 0.3)

      assert_in_delta 26.451862, result.max_latitude, 0.000003
      assert_in_delta 80.309586, result.max_longitude, 0.000003
      assert_in_delta 26.443179, result.min_latitude, 0.000003
      assert_in_delta 80.299887, result.min_longitude, 0.000003
    end
  end
end

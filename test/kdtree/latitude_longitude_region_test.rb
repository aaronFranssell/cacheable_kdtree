require 'test_helper'

class Kdtree::LatitudeLongitudeRegionTest < Minitest::Test
  describe 'initialize' do
    it 'should find the min and max values for each side of the region when given a pair of coordinates' do
      result = Kdtree::LatitudeLongitudeRegion.new(1, 2, 3, 0)

      assert_equal 1, result.min_latitude
      assert_equal 3, result.max_latitude
      assert_equal 0, result.min_longitude
      assert_equal 2, result.max_longitude
    end
  end

  describe 'merge_point' do
    it 'should find the min and max values for each side of the region when merging in a new coordinate pair' do
      region = Kdtree::LatitudeLongitudeRegion.new(1, 2, 3, 0)

      result = region.merge_point(0, 0)

      assert_equal 0, result.min_latitude
      assert_equal 3, result.max_latitude
      assert_equal 0, result.min_longitude
      assert_equal 2, result.max_longitude
    end
  end

  describe 'merge_region' do
    it 'should find the min and max values for each region' do
      region1 = Kdtree::LatitudeLongitudeRegion.new(1, 2, 3, 0)
      region2 = Kdtree::LatitudeLongitudeRegion.new(5, 1, -1, 1)

      result = region1.merge_region(region2)

      assert_equal(-1, result.min_latitude)
      assert_equal 5, result.max_latitude
      assert_equal 0, result.min_longitude
      assert_equal 2, result.max_longitude
    end
  end

  describe 'point_in_region?' do
    before do
      @class_under_test = Kdtree::LatitudeLongitudeRegion.new(1, 4, 4, 0)
    end

    it 'should return true if the point is in the region' do
      assert @class_under_test.point_in_region?(2, 2)
    end

    it 'should return false if the point is not in the region' do
      refute @class_under_test.point_in_region?(7, 7)
    end
  end

  describe 'regions_intersect?' do
    it 'should return false if the min latitude coordinate is greater than the max of the other' do
      r1 = Kdtree::LatitudeLongitudeRegion.new(2, 3, 4, 4)
      r2 = Kdtree::LatitudeLongitudeRegion.new(0, 3, 1, 4)

      refute Kdtree::LatitudeLongitudeRegion.regions_intersect?(r1, r2)
    end

    it 'should return false if the max latitude coordinate is less than the min of the other' do
      r1 = Kdtree::LatitudeLongitudeRegion.new(-2, 3, 0, 4)
      r2 = Kdtree::LatitudeLongitudeRegion.new(1, 3, 2, 4)

      refute Kdtree::LatitudeLongitudeRegion.regions_intersect?(r1, r2)
    end

    it 'should return false if the min longitude coordinate is greater than the max of the other' do
      r1 = Kdtree::LatitudeLongitudeRegion.new(1, 5, 2, 6)
      r2 = Kdtree::LatitudeLongitudeRegion.new(1, 3, 2, 4)

      refute Kdtree::LatitudeLongitudeRegion.regions_intersect?(r1, r2)
    end

    it 'should return false if the max longitude coordinate is less than the min of the other' do
      r1 = Kdtree::LatitudeLongitudeRegion.new(1, 0, 2, 1)
      r2 = Kdtree::LatitudeLongitudeRegion.new(1, 3, 2, 4)

      refute Kdtree::LatitudeLongitudeRegion.regions_intersect?(r1, r2)
    end

    it 'should return true if the regions intersect' do
      r1 = Kdtree::LatitudeLongitudeRegion.new(2, 2, 6, 6)
      r2 = Kdtree::LatitudeLongitudeRegion.new(0, 0, 4, 4)

      assert Kdtree::LatitudeLongitudeRegion.regions_intersect?(r1, r2)
    end
  end
end

class Kdtree::LatitudeLongitudeRegion
  attr_accessor :max_latitude, :max_longitude, :min_latitude, :min_longitude
  def initialize(lat1, long1, lat2, long2)
    @min_latitude, @max_latitude = [lat1, lat2].minmax
    @min_longitude, @max_longitude = [long1, long2].minmax
  end

  def merge_point(lat, long)
    new_min_lat, new_max_lat = [lat, @min_latitude, @max_latitude].minmax
    new_min_long, new_max_long = [long, @min_longitude, @max_longitude].minmax
    self.class.new(new_min_lat, new_min_long, new_max_lat, new_max_long)
  end

  def merge_region(region)
    new_min_lat, new_max_lat = [region.min_latitude, region.max_latitude, @min_latitude, @max_latitude].minmax
    new_min_long, new_max_long = [region.min_longitude, region.max_longitude, @min_longitude, @max_longitude].minmax
    self.class.new(new_min_lat, new_min_long, new_max_lat, new_max_long)
  end

  def point_in_region?(latitude, longitude)
    latitude.between?(min_latitude, max_latitude) && longitude.between?(min_longitude, max_longitude)
  end

  def to_s
    "min lat/long: (#{min_latitude}, #{min_longitude}) max lat/long (#{max_latitude}, #{max_longitude})"
  end

  def self.regions_intersect?(region1, region2)
    region1.min_latitude <= region2.max_latitude && region1.max_latitude >= region2.min_latitude &&
      region1.min_longitude <= region2.max_longitude && region1.max_longitude >= region2.min_longitude
  end
end

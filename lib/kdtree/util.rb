class Kdtree::Util
  EARTH_MILES = 3959.0
  EARTH_KILOMETERS = 6371.0

  # I pulled the algorithm for the bounding_box calculation from here:
  # http://stackoverflow.com/questions/1689096/calculating-bounding-box-a-certain-distance-away-from-a-lat-long-coordinate-in-j

  def self.bounding_box_miles(lat, long, distance_in_miles)
    bounding_box(lat, long, distance_in_miles, EARTH_MILES)
  end

  def self.bounding_box_kilometers(lat, long, distance_in_miles)
    bounding_box(lat, long, distance_in_miles, EARTH_MILES)
  end

  def self.bounding_box(lat, long, radius_distance, sphere_radius)
    lat_amount = radians_to_degrees(radius_distance / sphere_radius)
    lat1 = lat + lat_amount
    lat2 = lat - lat_amount
    long_amount = radians_to_degrees(radius_distance / sphere_radius / Math.cos(degrees_to_radians(lat)))
    long1 = long - long_amount
    long2 = long + long_amount
    Kdtree::LatitudeLongitudeRegion.new(lat1, long1, lat2, long2)
  end

  def self.degrees_to_radians(degrees)
    degrees * 3.1416 / 180
  end

  def self.radians_to_degrees(radians)
    radians * 180 / 3.1416
  end
end

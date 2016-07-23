class CacheableKdtree::Util
  KILOMETERS_IN_A_MILE = 0.621371192
  EARTH_KILOMETERS = 6371.0

  # I pulled the algorithm for the bounding_box calculation from here:
  # http://stackoverflow.com/questions/1689096/calculating-bounding-box-a-certain-distance-away-from-a-lat-long-coordinate-in-j

  def self.bounding_box_miles(lat, long, distance_in_miles)
    bounding_box(lat, long, distance_in_miles, earth_miles)
  end

  def self.bounding_box_kilometers(lat, long, distance_in_kilometers)
    bounding_box(lat, long, distance_in_kilometers, EARTH_KILOMETERS)
  end

  def self.bounding_box(lat, long, radius_distance, sphere_radius)
    lat_amount = radians_to_degrees(radius_distance / sphere_radius)
    lat1 = lat + lat_amount
    lat2 = lat - lat_amount
    long_amount = radians_to_degrees(radius_distance / sphere_radius / Math.cos(degrees_to_radians(lat)))
    long1 = long - long_amount
    long2 = long + long_amount
    CacheableKdtree::LatitudeLongitudeRegion.new(lat1, long1, lat2, long2)
  end

  def self.distance_kilometers(p1_lat, p1_long, p2_lat, p2_long)
    distance_law_of_cosines(p1_lat, p1_long, p2_lat, p2_long, EARTH_KILOMETERS)
  end

  def self.distance_miles(p1_lat, p1_long, p2_lat, p2_long)
    distance_law_of_cosines(p1_lat, p1_long, p2_lat, p2_long, earth_miles)
  end

  # I am using the law of cosines because it is faster than Haversine...
  def self.distance_law_of_cosines(p1_lat, p1_long, p2_lat, p2_long, sphere_radius)
    p1_lat = degrees_to_radians(p1_lat)
    p1_long = degrees_to_radians(p1_long)
    p2_lat = degrees_to_radians(p2_lat)
    p2_long = degrees_to_radians(p2_long)
    Math.acos(Math.sin(p1_lat) * Math.sin(p2_lat) +
              Math.cos(p1_lat) * Math.cos(p2_lat) * Math.cos(p2_long - p1_long)) * sphere_radius
  end

  def self.degrees_to_radians(degrees)
    degrees * Math::PI / 180
  end

  def self.radians_to_degrees(radians)
    radians * 180 / Math::PI
  end

  def self.earth_miles
    KILOMETERS_IN_A_MILE * EARTH_KILOMETERS
  end
end

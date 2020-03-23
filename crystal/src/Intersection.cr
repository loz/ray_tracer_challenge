def intersection(t, object)
  Intersection.new(t, object)
end

def intersections(i1 : Intersection, i2 : Intersection)
  set = [] of Intersection
  set << i1
  set << i2
  set
end

class Intersection
  getter t, object

  def initialize(@t : Float64, @object : Sphere)
  end
end

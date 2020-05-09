def plane()
  Plane.new
end


class Plane < Shape

  EPSILON = 0.0001

  def implement_normal_at(p)
    vector(0.0, 1.0, 0.0)
  end

  def implement_intersect(ray)
    result = Intersections.new
    if ray.direction.y.abs > EPSILON
      t1 = -ray.origin.y / ray.direction.y
      result << intersection(t1, self)
    end
    result
  end

  def bounds
    Bounds.new point(-Float64::INFINITY,0.0,-Float64::INFINITY),
               point( Float64::INFINITY,0.0, Float64::INFINITY)
  end
end

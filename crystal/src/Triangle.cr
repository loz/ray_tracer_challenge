def triangle(p1, p2, p3)
  Triangle.new(p1, p2, p3)
end

class Triangle < Shape

  getter p1, p2, p3
  getter e1 : Vector, e2 : Vector, normal : Vector

  def initialize(@p1 : Point, @p2 : Point, @p3 : Point)
    super()
    @e1 = @p2 - @p1
    @e2 = @p3 - @p1
    @normal = @e2.cross(@e1).normalize
  end

  def bounds
    xs = [@p1.x, @p2.x, @p3.x]
    ys = [@p1.y, @p2.y, @p3.y]
    zs = [@p1.z, @p2.z, @p3.z]
    Bounds.new point(xs.min, ys.min, zs.min),
               point(xs.max, ys.max, zs.max)
  end

  def implement_normal_at(point)
    normal
  end

  def implement_intersect(ray)
    result = Intersections.new
    dir_cross_e2 = ray.direction.cross e2
    det = e1.dot dir_cross_e2
    return result if det.abs < Float64::EPSILON

    f = 1.0 / det

    p1_to_origin = ray.origin - p1
    u = f * p1_to_origin.dot(dir_cross_e2)

    return result if u < 0.0 || u > 1.0

    origin_cross_e1 = p1_to_origin.cross(e1)
    v = f * ray.direction.dot(origin_cross_e1)

    return result if v < 0.0 || (u + v) > 1.0

    t = f * e2.dot(origin_cross_e1)

    result << intersection(t, self)

    result
  end
end

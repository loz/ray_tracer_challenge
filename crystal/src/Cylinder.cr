def cylinder
  Cylinder.new
end

class Cylinder < Shape
  EPSILON = 0.00001

  def implement_intersect(ray)
    result = Intersections.new
    a = ray.direction.x**2 + ray.direction.z**2

    return result if a < EPSILON

    b = (2.0 * ray.origin.x * ray.direction.x) +
        (2.0 * ray.origin.z * ray.direction.z)

    c = ray.origin.x**2 + ray.origin.z**2 - 1.0

    disc = b**2 - (4.0 * a * c)

    return result if disc < 0.0

    t0 = (-b - Math.sqrt(disc)) / (2 * a)
    t1 = (-b + Math.sqrt(disc)) / (2 * a)

    result << intersection(t0, self)
    result << intersection(t1, self)

    result
  end

  def implement_normal_at(point)
    vector(point.x, 0.0, point.z)
  end
end

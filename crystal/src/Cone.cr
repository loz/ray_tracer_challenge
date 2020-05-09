def cone
  Cone.new
end


class Cone < Cylinder

  def implement_intersect(ray)
    result = Intersections.new
    a = ray.direction.x**2 - ray.direction.y**2 + ray.direction.z**2


    b = (2.0 * ray.origin.x * ray.direction.x) -
        (2.0 * ray.origin.y * ray.direction.y) +
        (2.0 * ray.origin.z * ray.direction.z)

    c = ray.origin.x**2 -
        ray.origin.y**2 +
	ray.origin.z**2

    if a == 0.0 && b != 0.0
      t = -c / (2*b)
      result << intersection(t, self)
      intersect_caps(ray, result)
      return result
    end

    disc = b**2 - (4.0 * a * c)
    
    return result if disc < 0.0

    t0 = (-b - Math.sqrt(disc)) / (2 * a)
    t1 = (-b + Math.sqrt(disc)) / (2 * a)

    if t0 > t1
      tmp = t1
      t1 = t0
      t0 = tmp
    end

    y0 = ray.origin.y + t0 * ray.direction.y
    y1 = ray.origin.y + t1 * ray.direction.y

    result << intersection(t0, self) if minimum < y0 && y0 < maximum
    result << intersection(t1, self) if minimum < y1 && y1 < maximum
    intersect_caps(ray, result)
    result
  end

  def check_cap(ray, t, radius)
    x = ray.origin.x + t * ray.direction.x
    z = ray.origin.z + t * ray.direction.z
    x**2 + z**2 <= radius.abs
  end

  def implement_normal_at(point)
    dist = point.x**2 + point.z**2
    if dist < 1.0 
      return vector(0.0, 1.0, 0.0) if point.y >= maximum + Float64::EPSILON
      return vector(0.0, -1.0, 0.0) if point.y <= minimum + Float64::EPSILON
    end

    y = Math.sqrt(dist)
    y = -y if point.y > 0.0

    vector(point.x, y, point.z)
  end

  def bounds
    largest = {minimum.abs, maximum.abs}.max

    Bounds.new point(-largest, minimum,-largest),
               point( largest, maximum, largest)
  end

end

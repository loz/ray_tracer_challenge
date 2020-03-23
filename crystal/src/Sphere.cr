def sphere()
  Sphere.new()
end

class Sphere
  property transform : Matrix::Base

  def initialize()
    @transform = identity_matrix
  end

  def intersect(ray)
    tray = ray.transform(transform.inverse)

    result = [] of Intersection
    s = tray.origin - point(0.0, 0.0, 0.0)

    a = tray.direction.dot(tray.direction)
    b = 2.0 * tray.direction.dot(s)
    c = s.dot(s) - 1.0

    discriminant = (b*b) - (4.0 * a * c)

    if discriminant < 0.0
      return result
    end

    t1 = (0.0 - b - Math.sqrt(discriminant)) / (2 * a)
    t2 = (0.0 - b + Math.sqrt(discriminant)) / (2 * a)

    intersections(
    	intersection(t1, self),
	intersection(t2, self)
	)
  end

end

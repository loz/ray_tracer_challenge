def sphere()
  Sphere.new()
end

def glass_sphere()
  s = Sphere.new()
  s.material.transparency = 1.0
  s.material.refractive_index = 1.5
  s
end

class Sphere < Shape

  def implement_intersect(tray)
    result = Intersections.new

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

  def implement_normal_at(object_point)
    object_point - point(0.0, 0.0, 0.0)
  end

end

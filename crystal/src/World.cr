def world()
  World.new
end

def default_world()
  w = world()
  w.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))
  s = sphere()
  s.material.color = color(0.8, 1.0, 0.6)
  s.material.diffuse = 0.7
  s.material.specular = 0.2
  s
  w.objects << s
  s = sphere()
  s.transform = s.transform.scale(0.5, 0.5, 0.5)
  w.objects << s
  w
end

class World
  property objects = [] of Shape
  property light : Lights::Point

  def initialize()
    @light = point_light(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 0.0))
  end

  def intersect(r)
    intersections = Intersections.new
    objects.each do |object|
      intersections.append(object.intersect(r))
    end
    intersections
  end

  def is_shadowed?(point)
    v = light.position - point
    distance = v.magnitude
    direction = v.normalize

    r = ray(point, direction)
    intersections = intersect(r)

    h = intersections.hit
    if !h.null? && h.t < distance
      return true
    else
      return false
    end
  end

  def shade_hit(comps, recursion = 5)
    if light.nil?
      black
    else
      shadow = is_shadowed?(comps.over_point)
      surface = comps.object.material.lighting(comps.object, light, comps.point, comps.eyev, comps.normalv, shadow)
      reflected = reflected_color(comps, recursion)
      refracted = refracted_color(comps, recursion)
      surface + reflected + refracted
    end
  end

  def color_at(ray, recursion = 5)
    intersects = intersect(ray)
    hit = intersects.hit
    if hit.null?
      black
    else
      comps = hit.prepare_computations(ray, intersects)
      shade_hit(comps, recursion)
    end
  end

  def reflected_color(comps, recursion = 5)
    return black if recursion < 1
    return black if comps.object.material.reflective == 0.0
    reflect_ray = ray(comps.over_point, comps.reflectv)
    rcolor = color_at(reflect_ray, recursion - 1)
    rcolor = rcolor * comps.object.material.reflective
    color(rcolor)
  end

  def refracted_color(comps, recursion = 5)
    return black if recursion < 1
    return black if comps.object.material.transparency == 0.0
    n_ratio = comps.n1 / comps.n2
    cos_i = comps.eyev.dot comps.normalv
    sin2_t = (n_ratio**2) * (1.0 - (cos_i**2))
    return black if sin2_t > 1.0
    cos_t = Math.sqrt(1.0 - sin2_t)

    direction = comps.normalv * (n_ratio * cos_i - cos_t) -
                comps.eyev * n_ratio

    refract_ray = ray(comps.under_point, direction)

    rcolor = color_at(refract_ray, recursion - 1) *
             comps.object.material.transparency
    color(rcolor)
  end
end

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
  property objects = [] of Sphere
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

  def shade_hit(comps)
    if light.nil?
      black
    else
      shadow = is_shadowed?(comps.over_point)
      comps.object.material.lighting(light, comps.point, comps.eyev, comps.normalv, shadow)
    end
  end

  def color_at(ray)
    intersects = intersect(ray)
    hit = intersects.hit
    if hit.null?
      black
    else
      comps = hit.prepare_computations(ray)
      shade_hit(comps)
    end
  end
end

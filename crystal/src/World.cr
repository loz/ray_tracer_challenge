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
  property light : Lights::Point | Nil

  def intersect(r)
    intersections = Intersections.new
    objects.each do |object|
      intersections.append(object.intersect(r))
    end
    intersections
  end
end

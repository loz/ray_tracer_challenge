require "./src/RayTracer"


SIZE = 250

wall_z = 10.0
wall_size = 7.0

ray_origin = point(0.0, 0.0, -5.0)
c = Canvas.new(SIZE,SIZE)

pixel_size = wall_size / SIZE
half = wall_size / 2.0

p pixel_size
p half

s = sphere()
s.material = material()
s.material.color = color(0.2, 0.8, 0.2)

light = point_light(point(-10.0, 10.0 , -10.0) , color(1.0, 1.0, 1.0))

SIZE.times do |y|
  print "."
  world_y = half - pixel_size * y

  SIZE.times do |x|
    world_x = -half + pixel_size * x

    position = point(world_x, world_y, wall_z)
    r = ray(ray_origin, (position - ray_origin).normalize)
    hit = s.intersect(r).hit
    unless hit.null?
      point = r.position(hit.t)
      normal = hit.object.normal_at(point)
      eye = -r.direction
      col = hit.object.material.lighting(light, point, eye, normal)
      c.write_pixel(x, y, col)
    end
  end
end

c.to_ppm_file("sphere_material.ppm")

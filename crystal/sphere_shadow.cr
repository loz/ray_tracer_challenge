require "./src/RayTracer"


SIZE = 500

c = Canvas.new(SIZE,SIZE)
red = color(1.0, 0.0, 0.0)

s = sphere()


SIZE.times do |y|
  print "."
  SIZE.times do |x|
  r = ray(point((x-(SIZE/2)) * 1.0, (y-(SIZE/2)) * 1.0, -1.0), vector(0.0, 0.0, 1.0))
  s.transform = scaling(0.48 * SIZE, 0.48 * SIZE, 0.48 * SIZE)
  hit = s.intersect(r).hit
  unless hit.null?
    c.write_pixel(x, SIZE - 1 - y, red)
  end
  end
end

c.to_ppm_file("sphere_shadow.ppm")

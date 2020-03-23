require "./src/RayTracer"


c = Canvas.new(100,100)
red = color(1.0, 0.0, 0.0)

s = sphere()


100.times do |y|
  100.times do |x|
  r = ray(point((x-50) * 1.0, (y-50) * 1.0, -1.0), vector(0.0, 0.0, 1.0))
  s.transform = scaling(48.0, 48.0, 48.0)
  hit = s.intersect(r).hit
  unless hit.null?
    c.write_pixel(x, 99 - y, red)
  end
  end
end

c.to_ppm_file("sphere_shadow.ppm")

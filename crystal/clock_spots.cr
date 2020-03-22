require "./src/RayTracer"


c = Canvas.new(100,100)
white = color(1.0, 1.0, 1.0)

offset = translation(50.0, 50.0, 0.0)
spot   = translation(0.0, 40.0, 0.0)
rot    = rotation_z(Math::PI/6.0).inverse
p = point(0.0, 0.0, 0.0)
p = spot * p

12.times do 
  op = offset * p
  x = op.x.to_i
  y = op.y.to_i
  c.write_pixel(x, 100 - y, white)
  p = rot * p
end

c.to_ppm_file("clock.ppm")

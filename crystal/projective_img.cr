require "./src/RayTracer"




def tick(env, proj)
  pos, vel = proj
  grav, wind = env
  position = pos + vel
  velocity = vel + grav + wind
  {position, velocity}
end

p = {point(0.0, 1.0, 0.0), vector(1.0, 1.0, 0.0).normalize }
e = {vector(0.0, -0.1, 0.0), vector(-0.01, 0.0, 0.0)}

c = Canvas.new(100,100)
red = color(1.0, 0.0, 0.0)

16.times do 
  pos, _ = p
  x = (pos.x * 10.0).to_i
  y = (pos.y * 10.0).to_i
  print "#{x}, #{y}\n"
  c.write_pixel(x, 100-y, red)
  p = tick(e, p)
end

c.to_ppm_file("test.ppm")

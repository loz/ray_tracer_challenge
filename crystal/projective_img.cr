require "./src/RayTracer"

c = Canvas.new(10,10)
red = color(1.0, 0.0, 0.0)
c.write_pixel(5, 5, red)

c.to_ppm_file("test.ppm")

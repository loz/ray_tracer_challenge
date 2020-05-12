require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
sa = stripe_pattern(black, red)
sa.transform = rotation_y(Math::PI/2.0)
sb = stripe_pattern(red, black)
sb.transform = rotation_y(Math::PI/2.0)
pattern = stripe_pattern(sa, sb)
floor.material.pattern = pattern
floor.material.reflective = 0.2

sky = plane()
sky.transform = translation(0.0, 15.0, 0.0)
sky.material.pattern = stripe_pattern(white, color(0.5, 0.5, 1.0))

world = world()
world.objects << floor
world.objects << sky

def colored_ball(col)
  ball = sphere()
  ball.material.color = col
  ball.material.diffuse = 0.7
  ball.material.specular = 0.3
  ball
end

ball = colored_ball(black)
ball.material.reflective = 1.0
world.objects << ball


rot = 2 * (Math::PI / 3.0)
3.times do |n|
  ball = colored_ball(black)
  ball.transform = rotation_y(rot * n + (rot / 2.0)) * 
                   translation(0.0, 0.0, 3.0)
  ball.material.reflective = 1.0
  world.objects << ball
end

colors = [red, green, blue]
3.times do |n|
  ball = colored_ball(colors[n])
  ball.transform = scaling(0.5, 0.5, 0.5) *
                   rotation_y(rot * n) * 
                   translation(0.0, -1.0, 5.0)
  ball.material.reflective = 0.3
  world.objects << ball
end



world.light = point_light(point(-5.0, 5.0, -5.0), color(1.0, 1.0, 1.0))

camera = camera(2000, 1000, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
#camera = camera(200, 100, Math::PI/3.0)
#camera = camera(50, 50, Math::PI/3.0)
camera.transform = view_transform(point(-4.0, 3.0, -7.5),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
#camera.transform = view_transform(point(0.0, 1.0, -8.0),
#                                  point(0.0, 1.0, 0.0),
#                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world, true)

puts "Saving..."
canvas.to_ppm_file("spheres_scene.ppm")

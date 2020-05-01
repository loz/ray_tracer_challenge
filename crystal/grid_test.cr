require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, -0.1, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.5
floor.material.diffuse = 0.5

nested = checks_pattern(red, white)
nested.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = nested


world = world()
world.objects << floor

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(500, 250, Math::PI/3.0)
#camera = camera(100, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 2.5, -5.0),
                                  point(0.0, 1.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("grid_test.ppm")

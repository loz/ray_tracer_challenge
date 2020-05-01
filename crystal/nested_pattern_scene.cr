require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, 0.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.5
floor.material.diffuse = 0.5

stripe1 = stripe_pattern(blue, white)
stripe1.transform = scaling(0.25, 0.25, 0.25) *
                    rotation_y(Math::PI/2.0)

stripe2 = stripe_pattern(red, black)
stripe2.transform = scaling(0.25, 0.25, 0.25)
nested = checks_pattern(stripe1, stripe2)
nested.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = nested


world = world()
world.objects << floor

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(500, 250, Math::PI/3.0)
#camera = camera(200, 100, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 1.5, -5.0),
                                  point(0.0, 1.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("nested_pattern_scene.ppm")

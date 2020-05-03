require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
#pattern = checks_pattern(color(0.20, 0.20, 0.20), color(0.5, 0.5, 0.5))
#pattern = checks_pattern(white, red)
sa = stripe_pattern(white, red)
sa.transform = rotation_y(Math::PI/2.0)
sb = stripe_pattern(red, white)
sb.transform = rotation_y(Math::PI/2.0)
pattern = stripe_pattern(sa, sb)
floor.material.pattern = pattern


glass = sphere()
glass.transform = translation(0.0, 4.2, 0.0) *
                  scaling(0.5, 0.5, 0.5)
glass.material = material()
glass.material.color = color(0.1, 0.1, 0.1)
glass.material.diffuse = 0.7
glass.material.specular = 0.3
glass.material.transparency = 0.8
glass.material.refractive_index = 1.5

air = sphere()
air.transform = translation(0.0, 4.2, 0.0) *
                scaling(0.25, 0.25, 0.25)
air.material = material()
air.material.color = black
air.material.transparency = 1.0
air.material.refractive_index = 1.0

world = world()
world.objects << floor
world.objects << glass
world.objects << air

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(400, 400, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
#camera = camera(100, 100, Math::PI/3.0)
#camera = camera(50, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 5.25, 0.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 0.0, 1.0))
#camera.transform = view_transform(point(0.0, 1.0, -8.0),
#                                  point(0.0, 1.0, 0.0),
#                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("fresnel_scene.ppm")

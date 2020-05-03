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
glass.transform = scaling(2.5, 2.5, 2.5) *
                  translation(0.0, 0.0, 0.0)
glass.material = material()
glass.material.color = color(0.1, 0.1, 0.1)
glass.material.diffuse = 0.7
glass.material.specular = 0.3
glass.material.reflective = 0.2
glass.material.transparency = 0.8
glass.material.refractive_index = 1.5

air = sphere()
air.transform = scaling(1.35, 1.35, 1.35) *
                  translation(0.0, 0.0, 0.0)
air.material = material()
air.material.color = color(0.0, 0.0, 0.0)
air.material.transparency = 1.0
air.material.refractive_index = 1.0

world = world()
world.objects << floor
world.objects << glass
world.objects << air

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

#camera = camera(2500, 1250, Math::PI/3.0) #1.5 hrs +
camera = camera(200, 200, Math::PI/3.0)
#camera = camera(100, 100, Math::PI/3.0)
#camera = camera(50, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 5.25, 0.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 0.0, 1.0))
#camera.transform = view_transform(point(0.0, 0.0, -10.0),
#                                  point(0.0, 0.0, 0.0),
#                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("fresnel_scene.ppm")

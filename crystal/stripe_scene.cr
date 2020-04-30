require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, 0.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
floor.material.pattern = stripe_pattern(color(0.20, 0.20, 0.20), color(0.5, 0.5, 0.5))

middle = sphere()
middle.transform = translation(-0.5, 1.0, 0.5)
middle.material = material()
middle.material.color = color(0.1, 1.0, 0.1)
middle.material.diffuse = 0.7
middle.material.specular = 0.3
middle.material.pattern = stripe_pattern(color(0.1, 1.0, 0.1), color(0.5, 1.0, 0.5))

right = sphere()
right.transform = translation(2.0, 0.5, -0.5) *
                  scaling(0.5, 0.5, 0.5)
right.material = material()
right.material.color = color(0.1, 0.1, 1.0)
right.material.diffuse = 0.7
right.material.specular = 0.3
right.material.pattern = stripe_pattern(color(0.1, 0.1, 1.0), color(0.5, 0.5, 1.0))

left = sphere()
left.transform = translation(-2.0, 0.33, -0.75) *
                  scaling(0.33, 0.33, 0.33)
left.material = material()
left.material.color = color(1.0, 0.1, 0.1)
left.material.diffuse = 0.7
left.material.specular = 0.3
left.material.pattern = stripe_pattern(color(1.0, 0.1, 0.1), color(1.0, 0.5, 0.5))

world = world()
world.objects << floor
world.objects << middle
world.objects << right
world.objects << left

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(500, 250, Math::PI/3.0)
#camera = camera(100, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 1.5, -5.0),
                                  point(0.0, 1.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("stripe_scene.ppm")

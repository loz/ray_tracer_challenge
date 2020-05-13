require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.20, 0.20, 0.20), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern
floor.material.reflective = 0.7

middle = cube()
middle.transform = rotation_y(Math::PI/4.0)
middle.material = material()
middle.material.color = color(1.0, 1.0, 0.0)
middle.material.diffuse = 0.7
middle.material.specular = 0.3
middle.material.reflective = 0.8

right = sphere()
right.transform = translation(0.0, 0.5, -0.7)
right.material = material()
right.material.color = red
right.material.diffuse = 0.7
right.material.specular = 0.3

shape = csg(:difference, middle, right)

world = world()
world.objects << floor
world.objects << shape

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(2500, 1250, Math::PI/3.0)
#camera = camera(500, 250, Math::PI/3.0)
#camera = camera(100, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 3.0, -6.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world, true)

puts "Saving..."
canvas.to_ppm_file("csg_scene.ppm")

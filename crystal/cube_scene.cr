require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, 0.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.20, 0.20, 0.20), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern

middle = sphere()
middle.transform = translation(-1.0, 1.0, 4.0)
middle.material = material()
middle.material.color = color(0.1, 1.0, 0.1)
middle.material.diffuse = 0.7
middle.material.specular = 0.3
pattern = stripe_pattern(green, white)
pattern.transform = scaling(0.5, 0.5, 0.5)
middle.material.pattern = pattern

glass = cube()
glass.transform = translation(-0.5, 1.0, 0.5) *
                  rotation_y(Math::PI/4.0)
glass.material = material()
glass.material.color = color(0.1, 0.1, 0.1)
glass.material.diffuse = 0.2
glass.material.specular = 1.0
glass.material.shininess = 300.0
glass.material.reflective = 1.0
glass.material.transparency = 1.0
glass.material.refractive_index = 1.5

right = sphere()
right.transform = translation(2.0, 0.5, -0.5) *
                  scaling(0.5, 0.5, 0.5) *
		  rotation_z(Math::PI/4.0)
right.material = material()
right.material.color = color(0.1, 0.1, 1.0)
right.material.diffuse = 0.7
right.material.specular = 0.3
pattern = stripe_pattern(color(0.1, 0.1, 1.0), color(0.5, 0.5, 1.0))
pattern.transform = scaling(0.5, 0.5, 0.5)
right.material.pattern = pattern

left = sphere()
left.transform = translation(-2.0, 0.33, -0.75) *
                  scaling(0.33, 0.33, 0.33)
left.material = material()
left.material.color = color(1.0, 0.1, 0.1)
left.material.diffuse = 0.7
left.material.specular = 0.3
pattern = stripe_pattern(color(1.0, 0.1, 0.1), color(1.0, 0.5, 0.5))
pattern.transform = scaling(0.25, 0.25, 0.25) *
		    rotation_z(Math::PI/2.0)
left.material.pattern = pattern

world = world()
world.objects << floor
world.objects << glass
world.objects << middle
world.objects << right
world.objects << left

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

#camera = camera(2500, 1250, Math::PI/3.0) #1.5 hrs +
camera = camera(300, 150, Math::PI/3.0)
#camera = camera(100, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 1.5, -5.0),
                                  point(0.0, 1.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("cube_scene.ppm")

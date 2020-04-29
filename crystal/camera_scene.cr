require "./src/RayTracer"

floor = sphere()
floor.transform = scaling(10.0, 0.01, 10.0)
floor.material = material()
floor.material.color = color(1.0, 0.9, 0.9)
floor.material.specular = 0.0


left_wall = sphere()
left_wall.transform = translation(0.0, 0.0, 5.0) *
                      rotation_y(-Math::PI/4.0) *
                      rotation_x( Math::PI/2.0) *
                      scaling(10.0, 0.01, 10.0)

left_wall.material = floor.material

right_wall = sphere()
right_wall.transform = translation(0.0, 0.0, 5.0) *
                       rotation_y( Math::PI/4.0) *
                       rotation_x( Math::PI/2.0) *
                       scaling(10.0, 0.01, 10.0)

right_wall.material = floor.material

middle = sphere()
middle.transform = translation(-0.5, 1.0, 0.5)
middle.material = material()
middle.material.color = color(0.1, 1.0, 0.1)
middle.material.diffuse = 0.7
middle.material.specular = 0.3

right = sphere()
right.transform = translation(1.5, 0.5, -0.5) *
                  scaling(0.5, 0.5, 0.5)
right.material = material()
right.material.color = color(0.1, 0.1, 1.0)
right.material.diffuse = 0.7
right.material.specular = 0.3

left = sphere()
left.transform = translation(-1.5, 0.33, -0.75) *
                  scaling(0.33, 0.33, 0.33)
left.material = material()
left.material.color = color(1.0, 0.1, 0.1)
left.material.diffuse = 0.7
left.material.specular = 0.3

world = world()
world.objects << floor
world.objects << left_wall
world.objects << right_wall
world.objects << middle
world.objects << right
world.objects << left

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(500, 250, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 1.5, -5.0),
                                  point(0.0, 1.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world)

puts "Saving..."
canvas.to_ppm_file("camera_scene.ppm")

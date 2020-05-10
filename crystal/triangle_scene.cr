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

w = world()
w.objects << floor

middle = triangle point(-1.0, 0.0, 1.0),
                  point( 0.0, 1.0, 0.0),
                  point( 1.0, 0.0,-1.0)

middle.material = material()
middle.material.color = color(1.0, 1.0, 0.1)
middle.material.diffuse = 0.7
middle.material.specular = 0.3

w.objects << middle
    
w.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

#camera = camera(2500, 1250, Math::PI/3.0) #1.5 hrs +
#camera = camera(500, 250, Math::PI/3.0)
camera = camera(100, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 1.0, -3.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(w)

puts "Saving..."
canvas.to_ppm_file("triangle_scene.ppm")

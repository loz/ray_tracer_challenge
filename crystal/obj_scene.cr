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
#w.objects << floor

obj = ObjFile.parse_file("teapot-low.obj")
teapot = obj.to_group
teapot.transform = rotation_x(-Math::PI/2.0) *
                   rotation_y(Math::PI/8.0) *
                   rotation_z(Math::PI/16.0) *
                   translation(0.0, -20.0, 0.0)
w.objects << teapot
    
w.light = point_light(point(-15.0, 15.0, -15.0), color(1.0, 1.0, 1.0))


#camera = camera(2500, 1250, Math::PI/3.0) #1.5 hrs +
camera = camera(500, 250, Math::PI/3.0)
#camera = camera(200, 100, Math::PI/3.0)
#camera = camera(100, 50, Math::PI/3.0)
#camera = camera(50, 25, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 1.0, -40.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(w)

puts "Saving..."
canvas.to_ppm_file("obj_scene.ppm")

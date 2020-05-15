require "./src/RayTracer"
require "./model/pencil"
require "./src/animate"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.80, 0.80, 0.80), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern


world = world()
world.objects << floor
hb = pencil(red, true)
world.objects << hb

#camera = camera(2500, 2500, Math::PI/3.0)
#camera = camera(500, 250, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
camera = camera(300, 300, Math::PI/3.0)
#camera = camera(600, 600, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 4.0, -6.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))

lpos = point(-10.0, 10.0, -10.0)

world.light = point_light(lpos, color(1.0, 1.0, 1.0))
anim = false

if anim
  frames = 30
  rot = Math::PI * 2.0 / (frames * 1.0)
  animated(camera, world, frames) do |f|
    hb.transform = 
  		 rotation_y(-rot * f)
                 #rotation_z(rot * f) 
  end
else
  single(camera, world, "pencil")
end

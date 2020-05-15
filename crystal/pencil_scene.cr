require "./src/RayTracer"
require "./model/pencil"
require "./src/animate"

floor = plane()
floor.transform = translation(0.0, -0.2, 0.0)
floor.material = material()
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.80, 0.80, 0.80), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern


world = world()
world.objects << floor
hb = pencil(red, true)
hb.transform = rotation_y(-Math::PI/2.0) *
               translation(1.0, 0.0, -2.0)
world.objects << hb
colors = [
  blue, green, color(1.0, 1.0, 0.0),
  white, color(0.0, 1.0, 1.0), color(1.0, 0.0, 1.0),
  color(0.3, 0.3, 0.3)
]

set = Group.new
colors.each_with_index do |c, i|
  hb = pencil(c, true)
  hb.transform = 
                 translation(0.0, 0.0, i * 0.5) 
  set << hb
end

set.transform = rotation_y(Math::PI) *
                rotation_z(-Math::PI/64.0) *
		translation(0.0, 0.2, -3.0)
world.objects << set

#camera = camera(2500, 2500, Math::PI/3.0)
#camera = camera(500, 250, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
#camera = camera(300, 300, Math::PI/3.0)
camera = camera(600, 600, Math::PI/3.0)
view = view_transform(point(0.0, 4.0, -6.0),
                      point(0.0, 0.0, 0.0),
                      vector(0.0, 1.0, 0.0))
camera.transform = view
lpos = point(-10.0, 10.0, -10.0)

world.light = point_light(lpos, color(1.0, 1.0, 1.0))
anim = true

if anim
  frames = 36
  rot = Math::PI * 2.0 / (frames * 1.0)
  animated(camera, world, frames, 30) do |f|
    camera.transform = view *
  		       rotation_y(-rot * f)
  end
else
  single(camera, world, "pencil")
end

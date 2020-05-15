require "./src/RayTracer"
require "./model/pencil"
require "./model/glass"
require "./src/animate"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.80, 0.80, 0.80), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern

setup = group()
tumbler = glass()
water = liquid()
g = Group.new
g << tumbler
#g = CSG.new(:difference, tumbler, water)
#g = CSG.new(:union, g, water)
g.transform = scaling(2.0, 2.0, 2.0)

hb = pencil
hb.transform = translation(0.3, 3.5, 0.0) *
               rotation_z((Math::PI / 2.0) * 0.8)
setup << g
setup << hb

world = world()
world.objects << floor
world.objects << setup

#camera = camera(2500, 2500, Math::PI/3.0)
camera = camera(500, 500, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
#camera = camera(300, 300, Math::PI/3.0)
#camera = camera(600, 600, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
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
    camera.transform *= rotation_y(rot)
  end
else
  single(camera, world, "glass")
end

require "./src/RayTracer"
require "./src/animate"
require "./src/physics"


floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.80, 0.80, 0.80), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern

#camera = camera(2500, 2500, Math::PI/3.0)
#camera = camera(500, 500, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
#camera = camera(300, 300, Math::PI/3.0)
#camera = camera(600, 600, Math::PI/3.0)
camera = camera(200, 200, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 8.0, -8.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))

lpos = point(-10.0, 10.0, -10.0)

world = world()
world.objects << floor

ball = PhysicsObject.new point(0.0, 5.0, 0.0), vector(0.0, 0.0, 0.0)
pworld = PhysicsWorld.new
pworld << ball
ball = PhysicsObject.new point(-2.0, 3.5, 1.0), vector(0.0, 0.0, 0.0)
ball.shape.material.color = blue
pworld << ball
ball = PhysicsObject.new point(2.0, 8.0, -2.0), vector(0.0, 0.0, 0.0)
ball.shape.material.color = green
pworld << ball

pworld.apply(world)


world.light = point_light(lpos, color(1.0, 1.0, 1.0))
anim = true

if anim
  puts "Rendering..."
  frames = 100
  rot = Math::PI * 2.0 / (frames * 1.0)
  animated(camera, world, frames) do |f|
    camera.transform *= rotation_y(rot)
    pworld.tick(0.1)
  end
else
  single(camera, world, "water")
end

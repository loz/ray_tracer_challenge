require "./src/RayTracer"
require "./src/animate"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.80, 0.80, 0.80), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern

def water_material
  water = material()
  water.color = black()
  water.transparency = 1.0
  water.diffuse = 1.0
  water.specular = 1.0
  water.reflective = 1.0
  water.refractive_index = 1.3
  water.shadows = false
  water
end

#camera = camera(2500, 2500, Math::PI/3.0)
camera = camera(500, 500, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
#camera = camera(300, 300, Math::PI/3.0)
#camera = camera(600, 600, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 8.0, -8.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))

lpos = point(-10.0, 10.0, -10.0)

world = world()

world.objects << floor

g = Group.new
g2 = Group.new
g3 = Group.new

water_mat = water_material()
5.times do |x|
  5.times do |z|
    5.times do |y|
      s = sphere()
      s.material = water_mat
      s.transform = translation(-1.5 + (x*0.75), y * 0.75, -1.5 + (z*0.75))
      if y > 0
        g = CSG.new(:union, g, s)
      else 
        g = s
      end
    end
    if z > 0
      g2 = CSG.new(:union, g2, g)
    else 
      g2 = g
    end
  end
  if x > 0
    g3 =  CSG.new(:union, g3, g2)
  else
    g3 = g2
  end
end
world.objects << g3

world.light = point_light(lpos, color(1.0, 1.0, 1.0))
anim = false

if anim
  puts "Rendering..."
  frames = 30
  rot = Math::PI * 2.0 / (frames * 1.0)
  animated(camera, world, frames) do |f|
    camera.transform *= rotation_y(rot)
  end
else
  single(camera, world, "water")
end

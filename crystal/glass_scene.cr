require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.80, 0.80, 0.80), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern

def pencil()
  tpl = cube()
  tpl.material.color = color(1.0, 1.0, 0.0)
  tpl.transform = scaling(1.0, 1.0, 2.0)

  body = tpl.dup
  cut = tpl.dup
  cut.transform = rotation_x(Math::PI/1.5) *
                  scaling(1.0, 1.0, 2.0)
  body = CSG.new(:intersection, body, cut)

  cut = tpl.dup
  cut.transform = rotation_x(-Math::PI/1.5) *
                  scaling(1.0, 1.0, 2.0)
  body = CSG.new(:intersection, body, cut)
  body.transform = scaling(1.0, 0.04, 0.04) *
                   scaling(4.0, 4.0, 4.0)

  wood = material()
  pattern = ring_pattern(color(0.8, 0.6, 0.2), color(0.55, 0.4, 0.15))
  pattern.transform = scaling(0.03, 0.03, 1.0) *
                      rotation_x(Math::PI/10.0) *
		      rotation_z(Math::PI/13.5)
  wood.specular = 0.0
  wood.pattern = pattern

  cut = cone()
  cut.maximum = 40.0
  cut.minimum = 0.0
  cut.transform = translation(-4.0, 0.0, 0.0) *
                  rotation_z(-Math::PI/2.0) *
                  scaling(0.3, 1.0, 0.3)
  cut.material = wood
  body = CSG.new(:intersection, body, cut)

  cut = cube
  cut.material = wood
  cut.transform = translation(4.99, 0.0, 0.0)
  body = CSG.new(:difference, body, cut)

  cut = cube
  cut.material = wood
  cut.transform = translation(-4.8, 0.0, 0.0)
  body = CSG.new(:difference, body, cut)

  graphite = material()
  graphite.color = color(0.3, 0.3, 0.3)
  graphite.specular = 0.3
  graphite.diffuse = 0.9

  lead = cylinder()
  lead.material = graphite
  lead.maximum = 1.0
  lead.minimum = -1.0
  lead.closed = true
  lead.transform = rotation_z(Math::PI/2.0) *
                   scaling(0.015, 1.0, 0.015) *
                   scaling(4.0, 4.0, 4.0)
  cut = cone()
  cut.maximum = 40.0
  cut.minimum = 0.0
  cut.transform = translation(-4.0, 0.0, 0.0) *
                  rotation_z(-Math::PI/2.0) *
                  scaling(0.3, 1.0, 0.3)
  cut.material = graphite
  lead = CSG.new(:intersection, lead, cut)

  body = CSG.new(:union, body, lead)
  body
end

def glass()

  glass = material()
  glass.color = black()
  glass.transparency = 1.0
  glass.shininess = 300.0
  glass.diffuse = 0.1
  glass.specular = 0.1
  glass.refractive_index = 1.5
  glass.reflective = 1.0
  glass.shadows = false

  air = material()
  air.color = black()
  air.transparency = 1.0
  air.shininess = 300.0
  air.diffuse = 1.0
  air.specular = 1.0
  air.reflective = 1.0
  air.refractive_index = 1.0
  air.shadows = false

  base = cylinder()
  base.minimum = 2.0
  base.maximum = 3.25
  base.closed = true
  base.material = glass
  base.transform =  translation(0.0, -5.0, 0.0) *
                    scaling(0.6, 2.0, 0.6)

  inner = cylinder()
  inner.minimum = 2.0
  inner.maximum = 3.25
  inner.closed = true
  inner.material = air
  inner.transform =  translation(0.0, -5.0, 0.0) *
                    scaling(0.6, 2.0, 0.6) *
                    scaling(0.9, 0.9, 0.9) *
                    translation(0.0, 0.7, 0.0)
  obj = CSG.new(:difference, base, inner)
  obj
end

setup = group()
tumbler = glass()
tumbler.transform = scaling(2.0, 2.0, 2.0)
hb = pencil
hb.transform = translation(0.3, 3.5, 0.0) *
               rotation_z((Math::PI / 2.0) * 0.8)
setup << tumbler
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


def animated(camera, world, frames = 100)
  frames.times do |f|
    seq = sprintf("%03d", f)
    p seq
    yield f
    canvas = camera.render(world, true)
    puts "Saving..."
    canvas.to_ppm_file("seq/#{seq}.ppm")
  end
end

def single(camera, world, name)
  canvas = camera.render(world, true)
  puts "Saving"
  canvas.to_ppm_file("#{name}.ppm")
  `open #{name}.ppm`
end

puts "Rendering..."
#frames = 30
#rot = Math::PI * 2.0 / (frames * 1.0)
#animated(camera, world, frames) do |f|
#  hb.transform = 
#		 rotation_y(-rot * f)
#                 #rotation_z(rot * f) 
#end
single(camera, world, "glass")

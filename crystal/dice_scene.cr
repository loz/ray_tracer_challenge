require "./src/RayTracer"

floor = plane()
floor.transform = translation(0.0, -1.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.20, 0.20, 0.20), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern
floor.material.reflective = 0.7


def pips(side)
  grp = Group.new
  tpl = sphere()
  tpl.transform = scaling(0.2, 0.2, 0.1)

  if side == 1 || side == 3 || side == 5
    spot = tpl.dup
    grp << spot
  end

  if side == 4 || side == 6 || side == 5
    spot = tpl.dup
    spot.transform = spot.transform *
                   translation(-2.6,-2.6, 0.0)
    grp << spot

    spot = tpl.dup
    spot.transform = spot.transform *
                   translation( 2.6, 2.6, 0.0)
    grp << spot
  end

  if side == 6
    spot = tpl.dup
    spot.transform = spot.transform *
                   translation( 0.0,-2.6, 0.0)
    grp << spot

    spot = tpl.dup
    spot.transform = spot.transform *
                   translation( 0.0, 2.6, 0.0)
    grp << spot
  end

  if side != 1
    spot = tpl.dup
    spot.transform = spot.transform *
                   translation(-2.6, 2.6, 0.0)
    grp << spot


    spot = tpl.dup
    spot.transform = spot.transform *
                   translation( 2.6, -2.6, 0.0)
    grp << spot
  end

  grp.transform = translation(0.0, 0.0, -1.0)
  grp
end

def build_dice(mat)
  shape = cube()
  shape.material = mat


  cut = sphere()
  cut.material = mat
  cut.transform = scaling(1.5, 1.5, 1.5)
  c = csg(:intersection, shape, cut)

  cyl = cylinder
  cyl.material = mat
  cyl.minimum = -1.0
  cyl.maximum = 1.0
  cyl.closed = true
  cyl.transform = scaling(1.4, 1.4, 1.4)

  cut = cyl.dup
  c = csg(:intersection, c, cut)

  cut = cyl.dup
  cut.transform = cut.transform *
                  rotation_x(Math::PI/2.0)
  c = csg(:intersection, c, cut)

  cut = cyl.dup
  cut.transform = cut.transform *
                  rotation_z(Math::PI/2.0)
  c = csg(:intersection, c, cut)

  pip = pips(1)
  c = csg(:difference, c, pip)

  pip = pips(2)
  pip.transform = rotation_x(Math::PI/2.0) *
		  pip.transform
  c = csg(:difference, c, pip)

  pip = pips(6)
  pip.transform = rotation_x(Math::PI) *
		  pip.transform
  c = csg(:difference, c, pip)

  pip = pips(5)
  pip.transform = rotation_x(-Math::PI/2.0) *
		  pip.transform
  c = csg(:difference, c, pip)

  pip = pips(3)
  pip.transform = rotation_y(-Math::PI/2.0) *
		  pip.transform
  c = csg(:difference, c, pip)

  pip = pips(4)
  pip.transform = rotation_y(Math::PI/2.0) *
		  pip.transform
  c = csg(:difference, c, pip)
  c
end


world = world()
world.objects << floor

mat = material()
mat.shininess = 300.0
mat.specular = 0.0
mat.diffuse = 0.5
mat.reflective = 0.2

mred = mat.dup
mred.color = red
dice = build_dice(mred)
dice.transform = translation(-1.5, 0.0, 0.0) *
                 rotation_y(Math::PI/3.0)
world.objects << dice

mgrn = mat.dup
mgrn.color = green
dice = build_dice(mgrn)
dice.transform = translation( 1.5, 0.0, 0.0) *
                 rotation_y(Math::PI/5.0) *
		 rotation_x(Math::PI)
world.objects << dice

mblu = mat.dup
mblu.color = blue
mblu.transparency = 1.0
mblu.refractive_index = 1.5
mblu.reflective = 0.5
dice = build_dice(mblu)
dice.transform = translation( 0.0, 2.0, 0.0) *
		 rotation_y(-Math::PI/2.0) *
		 rotation_y(Math::PI/16.0)
world.objects << dice

world.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

camera = camera(2500, 2500, Math::PI/3.0)
#camera = camera(500, 250, Math::PI/3.0)
#camera = camera(200, 200, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 4.0, -6.0),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(world, true)

puts "Saving..."
canvas.to_ppm_file("dice_scene.ppm")

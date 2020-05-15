def pencil(paint = color(1.0, 1.0, 1.0), colored = false)
  mat = material()
  mat.color = paint

  tpl = cube()
  tpl.material = mat
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

  core = cylinder()
  core.maximum = 1.0
  core.minimum = -1.0
  core.closed = true
  core.material = mat
  core.transform = 
                   scaling(1.0, 0.043, 0.043) *
                   scaling(4.0, 4.0, 4.0) *
                   rotation_z(Math::PI/2.0)

  cut = cone()
  cut.maximum = 40.0
  cut.minimum = 0.0
  cut.transform = translation(-4.0, 0.0, 0.0) *
                  rotation_z(-Math::PI/2.0) *
                  scaling(0.3, 1.0, 0.3)
  cut.material = wood
  core = CSG.new(:intersection, core, cut)

  body = CSG.new(:intersection, body, core)

  cut = cube
  cut.material = wood
  cut.transform = translation(4.99, 0.0, 0.0)
  body = CSG.new(:difference, body, cut)

  cut = cube
  cut.material = wood
  cut.transform = translation(-4.8, 0.0, 0.0)
  body = CSG.new(:difference, body, cut)

  graphite = material()
  if colored
    graphite.color = (color(0.3, 0.3, 0.3) * 0.3) +
                     (mat.color * 0.7)
  else
    graphite.color = color(0.3, 0.3, 0.3)
  end
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

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

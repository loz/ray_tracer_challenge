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

def liquid()
  inner = cylinder()
  inner.minimum = 2.0
  inner.maximum = 3.25
  inner.closed = true
  inner.material = water_material
  inner.transform =  translation(0.0, -5.0, 0.0) *
                    scaling(0.6, 2.0, 0.6) *
                    scaling(0.9, 0.9, 0.9) *
                    translation(0.0, 0.7, 0.0)
                    #scaling(0.9999, 0.9999, 0.9999)
  return inner

  cut = cube()
  cut.material = water_material
  cut.transform = translation(0.0, 2.3, 0.0)

  g = CSG.new(:difference, inner, cut)
  g
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

  water = liquid()

  cut = cube()
  cut.material = air
  cut.transform = translation(0.0, 2.3, 0.0)
  a = liquid()
  a.material = air
  a = CSG.new(:intersection, a, cut)

  cut = cube()
  cut.material = water_material
  cut.transform = translation(0.0, 2.3, 0.0)
  l = CSG.new(:difference, water, cut)

  obj = CSG.new(:difference, base, a)
  obj = CSG.new(:difference, obj, l)
  obj
end

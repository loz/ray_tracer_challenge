require "./src/RayTracer"


def hexagon_corner()
  corner = sphere()
  corner.transform = translation(0.0, 0.0,-1.0) *
                     scaling(0.25, 0.25, 0.25)
  corner.material.color = color(0.2, 0.2, 0.2)
  corner.material.shininess = 300.0
  corner.material.reflective = 0.9
  corner
end

def hexagon_edge()
  edge = cylinder()
  edge.minimum = 0.0
  edge.maximum = 1.0
  edge.transform = translation(0.0, 0.0,-1.0) *
                   rotation_y(-Math::PI/6.0) *
                   rotation_z(-Math::PI/2.0) *
                   scaling(0.25, 1.0, 0.25)
  edge.material.color = color(0.2, 0.2, 0.2)
  edge.material.shininess = 300.0
  edge.material.reflective = 0.9
  edge
end

def hexagon_side()
  side = group()
  side << hexagon_corner
  side << hexagon_edge
  side
end

def hexagon()
  hex = group
  6.times do |n|
    side = hexagon_side()
    side.transform = rotation_y(n * Math::PI / 3.0)
    hex << side
  end
  hex
end

floor = plane()
floor.transform = translation(0.0, 0.0, 0.0)
floor.material = material()
floor.material.color = color(0.7, 0.7, 0.6)
floor.material.specular = 0.0
floor.material.diffuse = 0.5
pattern = stripe_pattern(color(0.20, 0.20, 0.20), color(0.5, 0.5, 0.5))
pattern.transform = rotation_y(Math::PI/4.0)
floor.material.pattern = pattern

w = world()
w.objects << floor

h = hexagon()
h.transform = translation(0.0, 1.0, 0.0) *
              rotation_x(-Math::PI/6.0) *
              rotation_z(-Math::PI/8.0)

w.objects << h

w.light = point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0))

#camera = camera(2500, 1250, Math::PI/3.0) #1.5 hrs +
camera = camera(500, 250, Math::PI/3.0)
#camera = camera(100, 50, Math::PI/3.0)
camera.transform = view_transform(point(0.0, 4.0, -2.5),
                                  point(0.0, 0.0, 0.0),
                                  vector(0.0, 1.0, 0.0))
puts "Rendering..."
canvas = camera.render(w)

puts "Saving..."
canvas.to_ppm_file("hexagon_scene.ppm")

def translation(x, y, z)
  matrix({
    {1.0, 0.0, 0.0, x},
    {0.0, 1.0, 0.0, y},
    {0.0, 0.0, 1.0, z},
    {0.0, 0.0, 0.0, 1.0},
  })
end

def scaling(x, y, z)
  matrix({
    {  x, 0.0, 0.0, 0.0},
    {0.0,   y, 0.0, 0.0},
    {0.0, 0.0,   z, 0.0},
    {0.0, 0.0, 0.0, 1.0},
  })
end

def rotation_z(r)
  matrix({
    {Math.cos(r), 0.0 - Math.sin(r), 0.0, 0.0},
    {Math.sin(r), Math.cos(r), 0.0, 0.0},
    {0.0, 0.0, 1.0, 0.0},
    {0.0, 0.0, 0.0, 1.0},
  })
end

def rotation_y(r)
  matrix({
    {Math.cos(r), 0.0, Math.sin(r), 0.0},
    {0.0, 1.0, 0.0, 0.0},
    {0.0 - Math.sin(r), 0.0,  Math.cos(r), 0.0},
    {0.0, 0.0, 0.0, 1.0},
  })
end

def rotation_x(r)
  matrix({
    {1.0, 0.0, 0.0, 0.0},
    {0.0, Math.cos(r), 0.0 - Math.sin(r), 0.0},
    {0.0, Math.sin(r),       Math.cos(r), 0.0},
    {0.0, 0.0, 0.0, 1.0},
  })
end

module Transformation
end

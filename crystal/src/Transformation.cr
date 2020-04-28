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

def shearing(xy, xz, yx, yz, zx, zy)
  matrix({
    {1.0,  xy,  xz, 0.0},
    { yx, 1.0,  yz, 0.0},
    { zx,  zy, 1.0, 0.0},
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

def view_transform(from, to, up)
  forward = (to - from).normalize
  upn = up.normalize
  left = forward.cross(upn)
  true_up = left.cross(forward)

  orientation = matrix({
    {left.x,     left.y,     left.z,     0.0},
    {true_up.x,  true_up.y,  true_up.z,  0.0},
    {-forward.x, -forward.y, -forward.z, 0.0},
    {0.0,        0.0,        0.0,        1.0}
  })
  orientation * translation(-from.x, -from.y, -from.z)
end

class Matrix::Base
  def rotate_x(r)
    rotation_x(r) * self
  end

  def rotate_y(r)
    rotation_y(r) * self
  end

  def rotate_z(r)
    rotation_z(r) * self
  end

  def scale(x, y, z)
    scaling(x, y, z) * self
  end

  def translate(x, y, z)
    translation(x, y, z) * self
  end
end

module Transformation

end


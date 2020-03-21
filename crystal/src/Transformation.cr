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

module Transformation
end

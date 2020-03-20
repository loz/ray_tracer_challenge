def point(x, y, z)
  RTuple.new(x, y, z, 1.0)
end

def vector(x, y, z)
  RTuple.new(x, y, z, 0.0)
end

class RTuple
  getter :x, :y, :z, :w
  def initialize(@x : Float64, @y : Float64, @z : Float64, @w : Float64)
  end

  def point?
    @w == 1.0
  end

  def vector?
    @w == 0.0
  end

  def magnitude
    Math.sqrt((x*x) + (y*y) + (z*z))
  end

  def normalize
    mag = magnitude
    RTuple.new(
    	x / mag,
	y / mag,
	z / mag,
	w / mag
	)
  end

  EPSILON = 0.00001
  def aproximate?(v : RTuple) 
    x >= (v.x - EPSILON) && x <= (v.x + EPSILON) &&
    y >= (v.y - EPSILON) && y <= (v.y + EPSILON) &&
    z >= (v.z - EPSILON) && z <= (v.z + EPSILON) &&
    w >= (v.w - EPSILON) && w <= (v.w + EPSILON)
  end

  def +(other)
    RTuple.new(
    	x + other.x,
	y + other.y,
	z + other.z,
	w + other.w
    )
  end

  def -() #Negate
    RTuple.new(0.0, 0.0, 0.0, 0.0) - self
  end

  def -(other)
    RTuple.new(
    	x - other.x,
	y - other.y,
	z - other.z,
	w - other.w
    )
  end

  def *(other : Float32)
    RTuple.new(
    	x * other,
	y * other,
	z * other,
	w * other
    )
  end

  def /(other : Float32)
    RTuple.new(
    	x / other,
	y / other,
	z / other,
	w / other
    )
  end

  def dot(other)
    (x * other.x) +
    (y * other.y) +
    (z * other.z)
  end

  def cross(other)
    vector(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x
    )
  end

  def ==(other)
    (x == other.x) &&
    (y == other.y) &&
    (z == other.z) &&
    (w == other.w)
  end
end

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
end

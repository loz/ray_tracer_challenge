def ray(o, d)
  Rays.new(o, d)
end


struct Rays
  getter origin, direction

  def initialize(@origin : RTuple, @direction : RTuple); end

  def position(t)
    origin + (direction * t)
  end

  def transform(m)
    ray(m * origin, m * direction)
  end
end

def ray(o, d)
  Rays.new(o, d)
end


class Rays
  getter origin, direction

  def initialize(@origin : RTuple, @direction : RTuple); end

  def position(t)
    origin + (direction * t)
  end
end

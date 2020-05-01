class Pattern
  getter a, b
  property transform : Matrix::Base

  def initialize(@a : Canvas::Color, @b : Canvas::Color)
    @transform = identity_matrix
  end

  def at(point)
    white
  end

  def at_object(object, world_point)
    object_point = object.transform.inverse * world_point
    pattern_point = @transform.inverse * object_point
    at(pattern_point)
  end
end

def stripe_pattern(a, b)
  Stripe.new(a, b)
end

def gradient_pattern(a, b)
  Gradient.new(a, b)
end


class Stripe < Pattern

  def at(point)
    if point.x.floor.to_i % 2 == 0
      a
    else
      b
    end
  end

end

class Gradient < Pattern
  getter distance : RTuple

  def initialize(a, b)
    super
    @distance = b - a  
  end

  def at(point)
     fraction = point.x - point.x.floor
     a + (@distance * fraction)
  end
end

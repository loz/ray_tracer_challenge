class Pattern
  property transform : Matrix::Base

  def initialize()
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


class Stripe < Pattern
  getter a, b

  def initialize(@a : Canvas::Color, @b : Canvas::Color)
    super()
  end

  def at(point)
    if point.x.floor.to_i % 2 == 0
      a
    else
      b
    end
  end

end

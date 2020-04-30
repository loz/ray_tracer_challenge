class Pattern
  def at(point)
    white
  end
end

def stripe_pattern(a, b)
  Stripe.new(a, b)

end


class Stripe < Pattern
  getter a, b

  def initialize(@a : Canvas::Color, @b : Canvas::Color)
  end

  def at(point)
    if point.x.floor.to_i % 2 == 0
      a
    else
      b
    end
  end

end

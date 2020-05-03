alias Tint = Canvas::Color | Pattern

class Pattern
  getter a, b
  property transform : Matrix::Base

  def initialize(@a : Tint, @b : Tint)
    @transform = identity_matrix
  end

  def at(point) : Canvas::Color
    white
  end

  def tint_a(point) : Canvas::Color
    if a.is_a? Pattern
      p = a.as(Pattern)
      pattern_point = p.transform.inverse * point
      p.at(pattern_point)
    else
      a.as(Canvas::Color)
    end
  end

  def tint_b(point) : Canvas::Color
    if b.is_a? Pattern
      p = b.as(Pattern)
      pattern_point = p.transform.inverse * point
      p.at(pattern_point)
    else
      b.as(Canvas::Color)
    end
  end

  def at_object(object, world_point) : Canvas::Color
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

def ring_pattern(a, b)
  Rings.new(a, b)
end

def checks_pattern(a, b)
  Checks.new(a, b)
end

def test_pattern()
  TestPattern.new(white, white)
end


class TestPattern < Pattern
  def at(point)
    color(point.x, point.y, point.z)
  end
end

class Stripe < Pattern

  def at(point)
    if point.x.floor.to_i % 2 == 0
      tint_a(point)
    else
      tint_b(point)
    end
  end

end

class Gradient < Pattern
  def at(point)
     ta = tint_a(point)
     tb = tint_b(point)
     distance = tb - ta  
     fraction = point.x - point.x.floor
     ta + (distance * fraction)
  end
end

class Rings < Pattern
  def at(point)
    ta = tint_a(point)
    tb = tint_b(point)

    dist = Math.sqrt((point.x * point.x) + (point.z * point.z)).floor.to_i
    if dist % 2 == 0
      ta
    else
      tb
    end
  end
end

class Checks < Pattern
  def at(point)
    ta = tint_a(point)
    tb = tint_b(point)
    x = point.x
    y = point.y
    z = point.z 
    dist = (x.floor + y.floor + z.floor)
    dist % 2 == 0 ? ta : tb
  end
end

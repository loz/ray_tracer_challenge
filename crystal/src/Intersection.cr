def intersection(t, object)
  Intersection.new(t, object)
end

def intersections(*ilist)
  set = Intersections.new
  ilist.each do |i|
    set << i
  end
  set
end


class Intersections
  EPSILON = 0.0001
  getter set

  def initialize()
    @set = [] of Intersection
  end

  def hit
    hits = @set.select {|i| i.t >= 0.0 }
    if hits.empty?
      NullIntersection.new
    else
      hits.min_by {|i| i.t } 
    end
  end

  def size
    @set.size
  end

  def <<(i)
    @set << i
  end

  def [](idx)
    @set[idx]
  end

  def append(other)
    @set += other.set
    @set.sort!
  end
end

class Intersection
  EPSILON = 0.0001
  getter t, object

  def initialize(@t : Float64, @object : Shape)
  end

  def <=>(other)
    t <=> other.t
  end

  def null?
    false
  end

  def prepare_computations(ray)
    point = ray.position(t)
    normalv = object.normal_at(point)
    eyev = -ray.direction

    if normalv.dot(eyev) < 0
      normalv = -normalv
      inside = true
      over_point = point + normalv * EPSILON
    else
      inside = false
      over_point = point + normalv * EPSILON
    end

    reflectv = ray.direction.reflect(normalv)

    Computations.new t,
      object,
      point,
      eyev,
      normalv,
      inside,
      over_point,
      reflectv
  end
end

class Intersection::Computations
  getter t, object, point, eyev, normalv, over_point, reflectv

  def initialize(@t : Float64, @object : Shape, @point : Point,  @eyev : Vector, @normalv : Vector, @inside : Bool, @over_point : Point, @reflectv : Vector)
  end

  def inside?
    @inside
  end
end

class NullIntersection < Intersection
  def initialize()
    @t = - 999_999_999_999_999.0
    @object = sphere()
  end

  def null?
    true
  end
end

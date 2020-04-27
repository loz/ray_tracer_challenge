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
  getter t, object

  def initialize(@t : Float64, @object : Sphere)
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
    else
      inside = false
    end

    Computations.new t,
      object,
      point,
      eyev,
      normalv,
      inside
  end
end

class Intersection::Computations
  getter t, object, point, eyev, normalv

  def initialize(@t : Float64, @object : Sphere, @point : Point,  @eyev : Vector, @normalv : Vector, @inside : Bool)
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

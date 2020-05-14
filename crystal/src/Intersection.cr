def intersection(t, object)
  Intersection.new(t, object, 0.0, 0.0)
end

def intersection_with_uv(t, object, u, v)
  Intersection.new(t, object, u, v)
end

def intersections(*ilist)
  set = Intersections.new
  ilist.each do |i|
    set << i
  end
  set
end

class Intersection
  EPSILON = 0.0001
  getter t, object, u, v

  def initialize(@t : Float64, @object : Shape, @u : Float64 = 0.0, @v : Float64 = 0.0)
  end

  def <=>(other)
    t <=> other.t
  end

  def null?
    false
  end

  def prepare_computations(ray, xs = Intersections.new)
    xs << self if xs.empty?
    point = ray.position(t)
    normalv = object.normal_at(point, self)
    eyev = -ray.direction

    if normalv.dot(eyev) < 0
      normalv = -normalv
      inside = true
    else
      inside = false
    end
    over_point = point + normalv * EPSILON
    under_point = point - normalv * EPSILON

    reflectv = ray.direction.reflect(normalv)

    comps = Computations.new t,
      object,
      point,
      eyev,
      normalv,
      inside,
      over_point,
      reflectv,
      under_point

    comps.calculate_n1_n2(xs, self)
    comps
  end
end

struct Intersections
  include Enumerable(Intersection)

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

  def empty?
    @set.empty?
  end

  def size
    @set.size
  end

  def <<(i)
    @set << i
  end
  
  def each
    @set.each do |i|
      yield i
    end
  end

  def reject
    result = Intersections.new
    each do |i|
      if !yield i
        result << i
      end
    end
    result
  end

  def [](idx)
    @set[idx]
  end

  def append(other)
    if @set.size == 0
      @set = other.set
      return
    elsif other.set.size == 0
      return #nothing to merge
    end
    @set.concat(other.set)
    @set.sort!
  end
end

struct Intersection::Computations
  getter t, object, point, eyev, normalv, over_point, reflectv, n1, n2, under_point

  def initialize(@t : Float64, @object : Shape, @point : Point,  @eyev : Vector, @normalv : Vector, @inside : Bool, @over_point : Point, @reflectv : Vector, @under_point : Point)
    @n1 = 0.0
    @n2 = 0.0
  end

  def inside?
    @inside
  end

  def schlick()
    cos = @eyev.dot @normalv

    if @n1 > @n2
      n = @n1 / @n2
      sin2_t = n**2 * (1.0 - cos**2)
      return 1.0 if sin2_t > 1.0

      cos_t = Math.sqrt(1.0 - sin2_t)
      cos = cos_t
    end

    r0 = ((@n1 - @n2) / (@n1 + @n2))**2
    return r0 + (1 - r0) * (1 - cos)**5
  end

  def calculate_n1_n2(xs, hit)
    containers = [] of Shape
    xs.each do |i|
      if i == hit
        if containers.empty?
          @n1 = 1.0
        else
          @n1 = containers.last.material.refractive_index
        end
      end

      if containers.includes? i.object
        containers.delete i.object
      else 
        containers << i.object
      end

      if i == hit
        if containers.empty?
          @n2 = 1.0
        else
          @n2 = containers.last.material.refractive_index
        end

        return
     end
    end
  end
end

class NullIntersection < Intersection
  def initialize()
    @t = - 999_999_999_999_999.0
    @object = sphere()
    @u = 0.0
    @v = 0.0
  end

  def null?
    true
  end
end

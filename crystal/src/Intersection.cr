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


struct Intersections
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

  def prepare_computations(ray, xs = Intersections.new)
    xs << self if xs.empty?
    point = ray.position(t)
    normalv = object.normal_at(point)
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

struct Intersection::Computations
  getter t, object, point, eyev, normalv, over_point, reflectv, n1, n2, under_point

  def initialize(@t : Float64, @object : Shape, @point : Point,  @eyev : Vector, @normalv : Vector, @inside : Bool, @over_point : Point, @reflectv : Vector, @under_point : Point)
    @n1 = 0.0
    @n2 = 0.0
  end

  def inside?
    @inside
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
  end

  def null?
    true
  end
end

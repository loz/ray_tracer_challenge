class Shape
  struct Bounds
    property min, max : Point
    def initialize(@min : Point, @max : Point); end
  end


  property transform : Matrix::Base
  property material : Materials::Base
  property parent : Shape

  def initialize()
    @transform = identity_matrix
    @material = Materials.material()
    @parent = NoShape.new
  end

  def ==(other)
    @transform == other.transform &&
    @material == other.material
  end

  def bounds
    Bounds.new point(-1.0,-1.0,-1.0),
               point( 1.0, 1.0, 1.0)
  end

  def include?(other)
    self.object_id == other.object_id #Non groups is exact match to self
  end

  def intersect(ray)
    tray = ray.transform(transform.inverse)
    implement_intersect(tray)
  end

  def world_to_object_space(point)
    unless parent.none?
      point = parent.world_to_object_space(point)
    end
    transform.inverse * point
  end

  def normal_to_world(normal)
    normal = transform.inverse.transpose * normal
    normal.fix_vector_w!
    normal = normal.normalize

    unless parent.none?
      normal = parent.normal_to_world(normal)
    end

    normal
  end

  def implement_intersect(ray)
    raise "NotImplemented"
  end

  def none?
    false
  end

  def normal_at(p, i : Intersection = NullIntersection.new)
    local_point = world_to_object_space(p)
    local_normal = implement_normal_at(local_point, i)
    normal_to_world(local_normal)
  end

  def implement_normal_at(point, hit : Intersection)
    raise "NotImplemented"
  end
end

class NoShape < Shape
  def initialize
    @transform = identity_matrix
    @material = Materials.material()
    @parent = self
  end

  def none?
    true
  end
end

class Shape 
  property transform : Matrix::Base
  property material : Materials::Base

  def initialize()
    @transform = identity_matrix
    @material = Materials.material()
  end

  def ==(other)
    @transform == other.transform &&
    @material == other.material
  end

  def intersect(ray)
    tray = ray.transform(transform.inverse)
    implement_intersect(tray)
  end

  def normal_at(p)
    object_point = transform.inverse * p
    object_normal = implement_normal_at(object_point)

    world_normal = transform.inverse.transpose * object_normal
    world_normal.fix_vector_w!
    return world_normal.normalize
  end
end


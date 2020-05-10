def group()
  Group.new
end

class Group < Shape

  getter children

  def initialize
    super
    @children = [] of Shape
    @bounds = Bounds.new(point(0.0, 0.0, 0.0), point(0.0, 0.0, 0.0))
  end

  def empty?
    @children.empty?
  end

  #Groups are not comparible unless same object
  def ==(other)
    other.object_id == object_id
  end

  def <<(child)
    child.parent = self
    @children << child
    calc_bounds!

  end

  def implement_intersect(ray)
    result = Intersections.new
    return result unless intersect_bbox?(ray)
    @children.each do |child|
      result.append child.intersect(ray)
    end
    result
  end

  def intersect_bbox?(ray)
    xtmin, xtmax = check_axis(ray.origin.x, ray.direction.x, @bounds.min.x, @bounds.max.x)
    ytmin, ytmax = check_axis(ray.origin.y, ray.direction.y, @bounds.min.y, @bounds.max.y)
    ztmin, ztmax = check_axis(ray.origin.z, ray.direction.z, @bounds.min.z, @bounds.max.z)
    tmin = {xtmin, ytmin, ztmin}.max
    tmax = {xtmax, ytmax, ztmax}.min
    return false if tmin > tmax
    return true
  end

  def check_axis(origin, direction, axis_min, axis_max)
    tmin_numerator = (axis_min - origin)
    tmax_numerator = (axis_max - origin)

    if direction.abs >= Float64::EPSILON
      tmin = tmin_numerator / direction
      tmax = tmax_numerator / direction
    else
      tmin = tmin_numerator * Float64::INFINITY
      tmax = tmax_numerator * Float64::INFINITY
    end

    if tmin > tmax
      return {tmax, tmin}
    else
      return {tmin, tmax}
    end
  end

  def bounds
    @bounds
  end

  def calc_bounds!
    xs = [] of Float64
    ys = [] of Float64
    zs = [] of Float64
    @children.each do |child|
      cbounds = child.bounds
      corners = all_corners(cbounds)
      corners.each do |point|
        point = child.transform * point
        xs << point.x
        ys << point.y
        zs << point.z
      end
    end
    @bounds = Bounds.new point(xs.min, ys.min, zs.min),
                         point(xs.max, ys.max, zs.max)
  end

  def all_corners(bbox)
    [
      bbox.min,
      point(bbox.min.x, bbox.min.y, bbox.max.z),
      point(bbox.min.x, bbox.max.y, bbox.min.z),
      point(bbox.min.x, bbox.max.y, bbox.max.z),
      point(bbox.max.x, bbox.min.y, bbox.min.z),
      point(bbox.max.x, bbox.min.y, bbox.max.z),
      point(bbox.max.x, bbox.max.y, bbox.min.z),
      bbox.max
    ]
  end
end

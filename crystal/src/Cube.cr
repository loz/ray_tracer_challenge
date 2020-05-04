def cube
  Cube.new
end

class Cube < Shape

  EPSILON = 0.00001
  INFINITY = Float32::INFINITY

  def implement_intersect(ray)
    result = Intersections.new
    xtmin, xtmax = check_axis(ray.origin.x, ray.direction.x)
    ytmin, ytmax = check_axis(ray.origin.y, ray.direction.y)
    ztmin, ztmax = check_axis(ray.origin.z, ray.direction.z)

    tmin = {xtmin, ytmin, ztmin}.max
    tmax = {xtmax, ytmax, ztmax}.min

    return result if tmin > tmax

    result << intersection(tmin, self)
    result << intersection(tmax, self)
    result
  end

  def implement_normal_at(point)
    maxc = {point.x.abs, point.y.abs, point.z.abs}.max
    
    if maxc == point.x.abs
      return vector(point.x, 0.0, 0.0)
    elsif maxc == point.y.abs
      return vector(0.0, point.y, 0.0)
    else
      return vector(0.0, 0.0, point.z)
    end
  end

  def check_axis(origin, direction)
    tmin_numerator = (-1.0 - origin)
    tmax_numerator = ( 1.0 - origin)

    if direction.abs >= EPSILON
      tmin = tmin_numerator / direction
      tmax = tmax_numerator / direction
    else
      tmin = tmin_numerator * INFINITY
      tmax = tmax_numerator * INFINITY
    end

    if tmin > tmax
      return {tmax, tmin}
    else
      return {tmin, tmax}
    end
  end
end

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

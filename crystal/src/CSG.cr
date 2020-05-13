def csg(op, left, right)
  CSG.new(op, left, right)
end

class CSG < Group
  getter operation, left, right

  def initialize(@operation : Symbol, @left : Shape, @right : Shape)
    super()
    @left.parent = self
    @right.parent = self
    @children = [@left, @right] #Ensures bounds work
  end

  def self.intersection_allowed(op, lhit, inl, inr)
    #TODO: Is this faster as a truth table lookup? (tests -> implementation)
    case op
      when :union
        return (lhit && !inr) || (!lhit && !inl)
      when :intersection
        return (lhit && inr) || (!lhit && inl)
      when :difference
        return (lhit && !inr) || (!lhit && inl)
    end
    false
  end

  def filter_intersections(xs) 
    result = Intersections.new
    inl = false
    inr = false

    xs.each do |i|
      lhit = left.include?(i.object)

      if CSG.intersection_allowed(operation, lhit, inl, inr)
        result << i
      end

      if lhit
        inl = !inl
      else
        inr = !inr
      end
    end

    result
  end

  def implement_intersect(ray)
    return Intersections.new unless intersect_bbox?(ray)
    xs = left.intersect(ray)
    rightxs = right.intersect(ray)

    xs.append(rightxs)

    filter_intersections(xs)
  end
end

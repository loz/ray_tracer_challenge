def group()
  Group.new
end

class Group < Shape

  def initialize
    super
    @children = [] of Shape
  end

  def empty?
    @children.empty?
  end

  def <<(child)
    child.parent = self
    @children << child
  end

  def implement_intersect(tray)
    result = Intersections.new
    @children.each do |child|
      result.append child.intersect(tray)
    end
    result
  end
end

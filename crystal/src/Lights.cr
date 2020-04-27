
def point_light(p, i)
  Lights::Point.new(p, i)
end

module Lights

  class Point
    getter position, intensity
    
    def initialize(@position : RTuple, @intensity : RTuple)
    end

    def ==(other)
      return false if other.nil?
      @position == other.position &&
      @intensity == other.intensity
    end
  end

end

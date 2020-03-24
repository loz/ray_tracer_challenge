
def point_light(p, i)
  Lights::Point.new(p, i)
end

module Lights

  class Point
    getter position, intensity
    
    def initialize(@position : RTuple, @intensity : RTuple)
    end
  end

end

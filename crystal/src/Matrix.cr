
def matrix(tuple)
  Matrix::Base.new(tuple)
end

module Matrix
  class Base
    getter size : Int32

    def initialize(tuple)
      size = tuple.size
      @content = Array(Array(Float64)).new
      size.times do |y|
        row = Array(Float64).new
        size.times do |x|
          row << tuple[x][y]
        end
        @content << row
      end
      @size = size
    end

    def [](x, y)
      @content[y][x]
    end

    def ==(other)
      return false unless size == other.size
      size.times do |y|
        size.times do |x|
          return false if self[x,y] != other[x,y]
        end
      end
      return true
    end

    def *(other : RTuple)
      col = Array(Float64).new
      size.times do |y|
        col << self[y,0] * other.x +
               self[y,1] * other.y +
               self[y,2] * other.z +
               self[y,3] * other.w
      end
      RTuple.new(col[0], col[1], col[2], col[3])
    end

    def *(other)
      result = Array(Array(Float64)).new
      size.times do |x|
        col = Array(Float64).new
        size.times do |y|
          val = 0.0
          size.times do |offset|
             val += (other[offset,y] * self[x, offset])
          end
          col << val
        end
        result << col
      end
      matrix(result)
    end
  end
end


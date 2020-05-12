
def matrix(tuple)
  Matrix::Base.new(tuple)
end

def identity_matrix()
  matrix( {
   { 1.0, 0.0, 0.0, 0.0 },
   { 0.0, 1.0, 0.0, 0.0 },
   { 0.0, 0.0, 1.0, 0.0 },
   { 0.0, 0.0, 0.0, 1.0 }
  })
end

module Matrix
  struct Base
    getter size : Int32

    getter content : Array(Array(Float64))

    def initialize(@size : Int32)
      @content = Array.new(@size) { Array.new(@size, 0.0) }
    end

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

    def invertible?
      determinant != 0.0
    end

    def inverse
      m = Matrix::Base.new(size)
      d = determinant
      size.times do |y|
        size.times do |x|
	  m[y,x] = (cofactor(x,y) / d) 
        end
      end
      m
    end

    def determinant
      if size == 2
        return (self[0,0] * self[1,1]) - 
               (self[1,0] * self[0,1])
      end
      total = 0.0
      size.times do |x|
        total += (self[0,x] * cofactor(0,x))
      end
      total
    end

    def minor(row, col)
      submatrix(row,col).determinant
    end

    def cofactor(row, col)
      if (row+col).odd?
        0 - minor(row, col)
      else
        minor(row, col)
      end
    end

    def submatrix(remrow, remcol)
      m = Matrix::Base.new(size-1)
      y = 0
      dy = 0
      nsize = size-1
      while dy < nsize
	y+=1 if y == remrow
        x = 0
        dx = 0
        while dx < nsize
	  x+=1 if x == remcol
	  m[dy,dx] = self[y,x]
	  x+=1
	  dx+=1
	end
	y+=1
	dy+=1
      end
      m
    end

    def transpose
      m = Array(Array(Float64)).new
      size.times do |y|
        row = Array(Float64).new
        size.times do |x|
          row << self[x,y]
        end
        m << row
      end
      matrix(m)
    end

    def dump
      print "\n"
      size.times do |y|
        print "[ "
        size.times do |x|
          print self[y,x]
          print " "
        end
        print "]\n"
      end
      print "\n"
    end

    def [](x, y)
      @content[y][x]
    end
    def []=(x, y, v)
      @content[y][x] = v
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

    EPSILON = 0.00001
    def approx(other)
      return false unless size == other.size
      size.times do |y|
        size.times do |x|
         if (self[x,y] < (other[x,y] - EPSILON)) ||
            (self[x,y] > (other[x,y] + EPSILON))
           return false
         end
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

    def +(other)
      m = Matrix::Base.new(size)
      d = determinant
      size.times do |y|
        size.times do |x|
	  m[y,x] = (other[y,x] + self[y, x])
        end
      end
      m
    end

    def *(other)
      m = Matrix::Base.new(size)
      d = determinant
      size.times do |y|
        size.times do |x|
          val = 0.0
          size.times do |offset|
             val += (other[offset,y] * self[x, offset])
          end
	  m[x,y] = val
        end
      end
      m
    end
  end
end


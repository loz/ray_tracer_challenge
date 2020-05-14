
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
  class Base
    getter size : Int32
    getter content : Array(Float64)

    @inverse : Nil | Matrix::Base
    @transposed : Nil | Matrix::Base

    def initialize(@size : Int32)
      @content = Array.new(@size*@size, 0.0)
    end

    def initialize(tuple)
      size = tuple.size
      @size = size
      @content = Array.new(@size*@size, 0.0)
      size.times do |y|
        size.times do |x|
          @content[(y*@size)+x] = tuple[x][y]
        end
      end
    end

    def invertible?
      determinant != 0.0
    end

    def inverse=(other : Matrix::Base)
      @inverse = other
    end

    def transposed=(other : Matrix::Base)
      @transposed = other
    end

    def inverse
      return @inverse.as(Matrix::Base) if @inverse
      m = Matrix::Base.new(size)
      d = determinant
      size.times do |y|
        size.times do |x|
	  m[y,x] = (cofactor(x,y) / d) 
        end
      end
      m.inverse = self
      @inverse = m
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
      return @transposed.as(Matrix::Base) if @transposed
      m = Matrix::Base.new(size)
      size.times do |y|
        size.times do |x|
          m[y,x] = self[x, y]
        end
      end
      m.transposed = self
      @transposed = m
      m
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
      @content[(y*size)+x]
    end
    def []=(x, y, v)
      @content[(y*size)+x] = v
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
      x, y, z, w = other.x, other.y, other.z, other.w
      # This is always size 4, so can be further deconstructed, as
      # all index (size * y) + x are fixed
      #RTuple.new(
      #  self[0,0] * x + self[0,1] * y + self[0,2] * z + self[0,3] * w,
      #  self[1,0] * x + self[1,1] * y + self[1,2] * z + self[1,3] * w,
      #  self[2,0] * x + self[2,1] * y + self[2,2] * z + self[2,3] * w,
      #  self[3,0] * x + self[3,1] * y + self[3,2] * z + self[3,3] * w 
      #  )
      RTuple.new(
        @content[0] * x + @content[4] * y + @content[ 8] * z + content[12] * w,
        @content[1] * x + @content[5] * y + @content[ 9] * z + content[13] * w,
        @content[2] * x + @content[6] * y + @content[10] * z + content[14] * w,
        @content[3] * x + @content[7] * y + @content[11] * z + content[15] * w
      )
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


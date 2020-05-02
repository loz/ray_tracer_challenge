def color(r, g, b)
  Canvas::Color.new(r, g, b, 1.0)
end

def color(t : RTuple)
  color(t.x, t.y, t.z)
end

def black()
  color(0.0, 0.0, 0.0)
end

def white()
  color(1.0, 1.0, 1.0)
end

def red()
  color(1.0, 0.0, 0.0)
end

def green()
  color(0.0, 1.0, 0.0)
end

def blue()
  color(0.0, 0.0, 1.0)
end


class Canvas
  getter width, height
  def initialize(@width : Int32, @height : Int32)
     @canvas = Array(Array(Color)).new
     @height.times do |h|
       row = Array(Color).new
       @width.times do |w|
       	row << color(0.0, 0.0, 0.0)
       end
       @canvas << row
     end
  end

  def pixel_at(x, y)
    @canvas[y][x]
  end

  def write_pixel(x, y, color)
    @canvas[y][x] = color.dup
  end

  def clamp(f : Float64, l : Int32, u : Int32)
    i = f.to_i32
    return u if i > u
    return l if i < l
    return i
  end

  def string_component(val, row, str)
    row += "#{val}"
    if row.size <= (70-4) 
       row += " "
    else 
       str += row + "\n"
       row = ""
    end
    {row, str}
  end

  def to_ppm_file(name)
    File.open(name, "w") do |f|
      f.print(to_ppm())
    end
  end

  def to_ppm
     str = "" +
     	   "P3\n" +
	   "#{@width} #{@height}\n" +
	   "255\n"
     @height.times do |h|
     	row = ""
	@width.times do |w|
	  color = pixel_at(w, h)
	  r = clamp(color.red * 255.0, 0, 255)
	  row, str = string_component(r, row, str)
	  g = clamp(color.green * 255.0, 0, 255)
	  row, str = string_component(g, row, str)
	  b = clamp(color.blue * 255.0, 0, 255)
	  row, str = string_component(b, row, str)
	end
	str += row.chomp(" ") + "\n"
     end
     str + "\n"
  end
end


class Canvas::Color < RTuple
  def red; x; end
  def green; y; end
  def blue; z; end

  def +(other : Canvas::Color)
    color(red + other.red, green + other.green, blue + other.blue) 
  end
end

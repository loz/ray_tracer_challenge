def camera(width, height, fov)
  Camera.new(width, height, fov)
end

class Camera
  getter hsize, vsize : Int32
  getter field_of_view : Float64
  property transform : Matrix::Base
  getter pixel_size : Float64

  getter half_width, half_height : Float64

  def initialize(@hsize : Int32, @vsize : Int32, @field_of_view : Float64)
    @transform = identity_matrix
    @half_height = 0.0
    @half_width = 0.0
    @pixel_size = calc_pixel_size
  end

  def render(world, progress = false)
    #channel = Channel(Int32).new
    start = Time.monotonic

    image = Canvas.new(hsize, vsize)
    (0...vsize).each do |y|
      #spawn do
        (0...hsize).each do |x|
          ray = ray_for_pixel(x, y)
          color = world.color_at(ray)
          image.write_pixel(x, y, color)
        end
	#channel.send y
      #end
      if progress
        elapsed = Time.monotonic - start
        perc = y / (vsize * 1.0)
	if perc > 0
	  remain = (elapsed / perc) * (1.0 - perc)
	  e_min = elapsed.total_minutes.floor.to_i
	  e_sec = elapsed.seconds
	  r_min = remain.total_minutes.floor.to_i
	  r_sec = remain.seconds
	  estimate = "#{e_min}min #{e_sec}s (est. #{r_min}min #{r_sec} remaining)"
	else
	  estimate = ""
	end
	print "\r\e[K #{(perc * 100.0).format(decimal_places: 2)}% #{estimate}"
      end
    end
    puts "\r\e[K 100.0%" if progress
    #(0...vsize).each do
    #  channel.receive
    #  putc "."
    #end
    image
  end

  def ray_for_pixel(px, py)
    xoffset = (px + 0.5) * pixel_size
    yoffset = (py + 0.5) * pixel_size

    world_x = @half_width - xoffset
    world_y = @half_height - yoffset

    pixel = transform.inverse * point(world_x, world_y, -1.0)
    origin = transform.inverse * point(0.0, 0.0, 0.0)

    direction = (pixel - origin).normalize

    ray(origin, direction)
  end

  def calc_pixel_size
    half_view = Math.tan(field_of_view / 2.0)
    aspect = hsize / vsize
    if aspect > 1.0
      @half_height = half_view / aspect
      @half_width  = half_view
    else
      @half_height = half_view
      @half_width  = half_view * aspect
    end

    (@half_width * 2.0) / hsize
  end
end

class ObjFile

  getter ignored
  getter default_group 
  getter vertices = [] of Point
  getter normals = [] of Vector

  def self.parse_file(fname)
    str = File.read(fname)
    parse(str)
  end

  def self.parse(string)
    obj = self.new
    string.each_line do |line|
      obj.parse_line(line)
    end
    obj
  end

  def to_group
    g = Group.new
    g << @default_group
    @named_groups.each do |name, grp|
      g << grp
    end
    g
  end

  def group(name)
    @named_groups[name]
  end

  def initialize
    @ignored = 0
    @vertices << point(0.0, 0.0, 0.0) #Sentinal, as 1-Index
    @normals << vector(0.0, 0.0, 0.0) #1-Indexed
    @default_group = Group.new
    @current_group = @default_group
    @named_groups = {} of String => Group
  end

  def parse_line(line)
    parse_vertex(line) ||
    parse_normal(line) ||
    parse_face(line) ||
    parse_group(line) ||
    ignore line
  end

  def ignore(line)
    @ignored += 1
  end

  def parse_vertex(line)
    if line.starts_with?("v ")
      points = line.split(/\s+/)
      @vertices << point(points[1].to_f, points[2].to_f, points[3].to_f)
      true
    end
  end

  def parse_normal(line)
    if line.starts_with?("vn ")
      points = line.split(/\s+/)
      @normals << vector(points[1].to_f, points[2].to_f, points[3].to_f)
      true
    end
  end

  def parse_group(line)
    if line.starts_with?("g ")
      name = line[2,line.size-2]
      g = Group.new
      @named_groups[name] = g
      @current_group = g
      true
    end
  end

  def parse_face(line)
    if line.starts_with?("f ")
      points = line.strip.split(" ")
      triangles = fan_triangulation(points)
      triangles.each do |tri|
        @current_group << tri
      end
      true
    end
  end

  def fan_triangulation(points)
    triangles = [] of Triangle
    ps1 = points[1].split("/")
    smooth = ps1.size > 1
    (points.size-3).times do |n|
      index = n + 2
      if smooth
        ps2 = points[index].split("/")
	ps3 = points[index+1].split("/")
        p1 = ps1[0].to_i
        p2 = ps2[0].to_i
        p3 = ps3[0].to_i
	n1 = ps1[2].to_i
	n2 = ps2[2].to_i
	n3 = ps3[2].to_i
        tri = smooth_triangle @vertices[p1],
	                      @vertices[p2],
			      @vertices[p3],
			      @normals[n1],
			      @normals[n2],
			      @normals[n3]
      else
        p1 = points[1].to_i
        p2 = points[index].to_i
        p3 = points[index+1].to_i
        tri = triangle @vertices[p1],
                     @vertices[p2],
                     @vertices[p3]
      end
      triangles << tri
    end
    triangles
  end
end

class ObjFile

  getter ignored
  getter default_group 
  getter vertices = [] of Point

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
    @default_group = Group.new
    @current_group = @default_group
    @named_groups = {} of String => Group
  end

  def parse_line(line)
    parse_vertex(line) ||
    parse_face(line) ||
    parse_group(line) ||
    ignore line
  end

  def ignore(line)
    @ignored += 1
  end

  def parse_vertex(line)
    if m = line.match(/^v\s+(?<x>-{0,1}\d+(\.\d+){0,1}) (?<y>-{0,1}\d+(\.\d+){0,1}) (?<z>-{0,1}\d+(\.\d+){0,1})/)
      @vertices << point(m["x"].to_f, m["y"].to_f, m["z"].to_f)
      true
    end
  end

  def parse_group(line)
    if m = line.match(/^g\s+(?<name>\w+)/)
      g = Group.new
      @named_groups[m["name"]] = g
      @current_group = g
      true
    end
  end

  def parse_face(line)
    if m = line.match(/^f\s+((\d+)\s*)+/)
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
    (points.size-3).times do |n|
      index = n + 2
      p1 = points[1].split("/")[0].to_i
      p2 = points[index].split("/")[0].to_i
      p3 = points[index+1].split("/")[0].to_i
      tri = triangle @vertices[p1],
                     @vertices[p2],
                     @vertices[p3]
      triangles << tri
    end
    triangles
  end
end

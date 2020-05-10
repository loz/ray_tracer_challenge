require "./spec_helper"

Spectator.describe ObjFile do
  let(parser) { ObjFile.parse(file) }

  describe "Handling unknown lines" do
    let(file) {
    <<-EOF
There was a young lady named Bright
who travelled much faster than light.
She set out one day
in a relative way,
and came back the previous night.
EOF
    }

    it "ignores the lines" do
      expect(parser.ignored).to eq 5
    end
  end

  describe "Vertex records" do
    let(file) {
    <<-EOF
v -1 1 0
v -1.0000 0.5000 0.0000
v 1 0 0
v 1 1 0
EOF
    }

    it "parses all vertices" do
      expect(parser.vertices[1]).to eq point(-1.0, 1.0, 0.0)
      expect(parser.vertices[2]).to eq point(-1.0, 0.5, 0.0)
      expect(parser.vertices[3]).to eq point( 1.0, 0.0, 0.0)
      expect(parser.vertices[4]).to eq point( 1.0, 1.0, 0.0)
    end
  end

  describe "Face records" do
    let(file) {
    <<-EOF
v -1 1 0
v -1 0 0
v 1 0 0
v 1 1 0

f 1 2 3
f 1 3 4
EOF
    }

    it "parses all faces into default group" do
      t1 = parser.default_group.children[0].as(Triangle)
      t2 = parser.default_group.children[1].as(Triangle)

      expect(t1.p1).to eq parser.vertices[1]
      expect(t1.p2).to eq parser.vertices[2]
      expect(t1.p3).to eq parser.vertices[3]

      expect(t2.p1).to eq parser.vertices[1]
      expect(t2.p2).to eq parser.vertices[3]
      expect(t2.p3).to eq parser.vertices[4]
    end
  end

  describe "Polygons" do
    let(file) {
    <<-EOF
v -1 1 0
v -1 0 0
v 1 0 0
v 1 1 0
v 0 2 0

f 1 2 3 4 5
EOF
    }

    it "parses all faces into triangles in default group" do
      t1 = parser.default_group.children[0].as(Triangle)
      t2 = parser.default_group.children[1].as(Triangle)
      t3 = parser.default_group.children[2].as(Triangle)

      expect(t1.p1).to eq parser.vertices[1]
      expect(t1.p2).to eq parser.vertices[2]
      expect(t1.p3).to eq parser.vertices[3]

      expect(t2.p1).to eq parser.vertices[1]
      expect(t2.p2).to eq parser.vertices[3]
      expect(t2.p3).to eq parser.vertices[4]

      expect(t3.p1).to eq parser.vertices[1]
      expect(t3.p2).to eq parser.vertices[4]
      expect(t3.p3).to eq parser.vertices[5]
    end
  end

  describe "Named Groups" do
    let(parser) { ObjFile.parse_file("triangles.obj") }
    let(g1) { parser.group("FirstGroup") }
    let(g2) { parser.group("SecondGroup") }

    let(t1) { g1.children[0].as(Triangle) }
    let(t2) { g2.children[0].as(Triangle) }

    it "organises triangles into named groups" do
      expect(t1.p1).to eq parser.vertices[1]
      expect(t1.p2).to eq parser.vertices[2]
      expect(t1.p3).to eq parser.vertices[3]

      expect(t2.p1).to eq parser.vertices[1]
      expect(t2.p2).to eq parser.vertices[3]
      expect(t2.p3).to eq parser.vertices[4]
    end
  end

  describe "Conversion To Model Group" do
    let(parser) { ObjFile.parse_file("triangles.obj") }
    let(g) { parser.to_group }

    it "includes all groups" do
      expect(g.children).to contain parser.default_group
      expect(g.children).to contain parser.group("FirstGroup")
      expect(g.children).to contain parser.group("SecondGroup")
    end
    
  end
end

require "./spec_helper"

class TestShape < Shape
  property saved_ray : Rays
  def initialize()
    super
    @saved_ray = ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 0.0))
  end

  def implement_intersect(ray)
    @saved_ray = ray
    Intersections.new
  end

  def implement_normal_at(point)
    point
  end
end

def test_shape()
  TestShape.new
end

Spectator.describe Shape do
  let(s) { test_shape() }

  describe "Parent" do
    it "has no parent by default" do
      expect(s.parent.none?).to be true
    end
  end

  describe "Transform" do
    describe "The default" do
      it "is the identity matrix" do
        expect(s.transform).to eq identity_matrix
      end
    end

    describe "Changing" do
      let(t) { translation(2.0, 3.0, 4.0) }

      it "sets to given transform" do
        s.transform = t
        expect(s.transform).to eq t
      end
    end
  end
  
  describe "Bounds" do
    let(s) { test_shape() }

    it "has bounds of 1 unit in each direction" do
      bounds = s.bounds
      expect(bounds.min).to eq point(-1.0,-1.0,-1.0)
      expect(bounds.max).to eq point( 1.0, 1.0, 1.0) 
    end
  end

  describe "Materials" do
    it "has default material" do
      expect(s.material).to eq material()
    end

    it "can be assign material" do
      m = material()
      m.ambient = 1.0

      s.material = m
      expect(s.material).to eq m
    end
  end

  describe "A ray intersecting" do
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }

    it "does so with scaling" do
      s.transform = scaling(2.0, 2.0, 2.0)
      xs = s.intersect(r)

      expect(s.saved_ray.origin).to eq point(0.0, 0.0, -2.5)
      expect(s.saved_ray.direction).to eq vector(0.0, 0.0, 0.5)
    end

    it "does so with translation" do
      s.transform = translation(5.0, 0.0, 0.0)
      xs = s.intersect(r)

      expect(s.saved_ray.origin).to eq point(-5.0, 0.0, -5.0)
      expect(s.saved_ray.direction).to eq vector(0.0, 0.0, 1.0)
    end
  end

  describe "Normals" do
    it "does so with translation" do
      s.transform = translation(0.0, 1.0, 0.0)
      n = s.normal_at(point(0.0, 1.70711, -0.70711))

      expect(n.approximate?(vector(0.0, 0.70711, -0.70711))).to be true
    end

    it "does so with transformation" do
      s.transform = scaling(1.0, 0.5, 1.0) *
                    rotation_z(Math::PI / 5.0)

      n = s.normal_at(point(0.0, Math.sqrt(2.0) / 2.0, -Math.sqrt(2.0) / 2.0))

      expect(n.approximate?(vector(0.0, 0.97014, -0.24254))).to be true
    end
  end

  describe "World to Object space" do
    let(g1) { group() }
    let(g2) { group() }
    let(s) { sphere() }
    before_each do
      g1.transform = rotation_y(Math::PI/2.0)
      g2.transform = scaling(2.0, 2.0, 2.0)
      s.transform = translation(5.0, 0.0, 0.0)
      g1 << g2
      g2 << s
    end

    it "translates through groups and parents" do
      p = s.world_to_object_space(point(-2.0, 0.0, -10.0))
      expect(p.approximate?(point(0.0, 0.0, -1.0))).to be true
    end
  end

  describe "Object to World space" do
    let(g1) { group() }
    let(g2) { group() }
    let(s) { sphere() }
    before_each do
      g1.transform = rotation_y(Math::PI/2.0)
      g2.transform = scaling(1.0, 2.0, 3.0)
      s.transform = translation(5.0, 0.0, 0.0)
      g1 << g2
      g2 << s
    end

    it "translates normals groups and parents" do
      n = s.normal_to_world(vector(Math.sqrt(3.0)/3.0, Math.sqrt(3.0)/3.0, Math.sqrt(3.0)/3.0))
      expect(n.approximate?(vector(0.28571, 0.42857,-0.85714))).to be true
    end

    it "finds normal within group" do
      n = s.normal_at(point(1.7321, 1.1547, -5.5774))
      expect(n.approximate?(vector(0.28570, 0.42854,-0.85716))).to be true
    end
  end

end

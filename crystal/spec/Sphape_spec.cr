require "./spec_helper"

class TestShape < Shape
  property saved_ray : Rays
  def initialize()
    super
    @saved_ray = ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 0.0))
  end

  def implement_intersect(ray)
    @saved_ray = ray
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
end

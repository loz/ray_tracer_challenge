require "./spec_helper"

Spectator.describe Sphere do
  describe "A ray intersecting a sphere" do
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "does so at two time points" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq 4.0
      expect(xs[1].t).to eq 6.0
    end
  end

  describe "A ray intersecting a sphere at a tangent" do
    let(r) { ray(point(0.0, 1.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "does so at two co-incident time points" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq 5.0
      expect(xs[1].t).to eq 5.0
    end
  end

  describe "A ray missing a sphere" do
    let(r) { ray(point(0.0, 2.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "does not intersect" do
      xs = s.intersect(r)
      expect(xs.size).to eq 0
    end
  end

  describe "A ray originating within a sphere" do
    let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "intersects with both positive and negative time(t)" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq -1.0
      expect(xs[1].t).to eq  1.0
    end
  end

  describe "A ray originating behind a sphere" do
    let(r) { ray(point(0.0, 0.0, 5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "intersects with two negative times(t)" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq -6.0
      expect(xs[1].t).to eq -4.0
    end
  end

  describe "Ray intersects are Intersect objects, including t and object hit" do
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "does so at two time points" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq 4.0
      expect(xs[1].t).to eq 6.0
      expect(xs[0].object).to eq s
      expect(xs[1].object).to eq s

    end
  end

  describe "Transform" do
    describe "The default" do
      let(s) { sphere() }
      
      it "is the identity matrix" do
        expect(s.transform).to eq identity_matrix
      end
    end

    describe "Changing" do
      let(s) { sphere() }
      let(t) { translation(2.0, 3.0, 4.0) }

      it "sets to given transform" do
        s.transform = t
        expect(s.transform).to eq t
      end
    end

    describe "Intersecting with" do
      let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
      let(s) { sphere() }

      it "accounts for a scaling transform" do
        s.transform = scaling(2.0, 2.0, 2.0)
        xs = s.intersect(r)

        expect(xs.size).to eq 2
        expect(xs[0].t).to eq 3.0
        expect(xs[1].t).to eq 7.0
      end

      it "accounts for a translation transform" do
        s.transform = translation(5.0, 0.0, 0.0)
        xs = s.intersect(r)

        expect(xs.size).to eq 0
      end
    end
  end

  describe "Normals" do
    describe "at a point on x axis" do
      let(s) { sphere() }
      
      it "is a vector at right angles to tangent" do
        expect(s.normal_at(point(1.0, 0.0, 0.0))).to eq vector(1.0, 0.0, 0.0)
      end

    end

    describe "at a point on y axis" do
      let(s) { sphere() }
      
      it "is a vector at right angles to tangent" do
        expect(s.normal_at(point(0.0, 1.0, 0.0))).to eq vector(0.0, 1.0, 0.0)
      end

    end

    describe "at a point on z axis" do
      let(s) { sphere() }
      
      it "is a vector at right angles to tangent" do
        expect(s.normal_at(point(0.0, 0.0, 1.0))).to eq vector(0.0, 0.0, 1.0)
      end

    end

    describe "at a point on non-axial point" do
      let(s) { sphere() }
      
      it "is a vector at right angles to tangent of point" do
        n = s.normal_at(point(Math.sqrt(3.0)/3.0,Math.sqrt(3.0)/3.0,Math.sqrt(3.0)/3.0))
	expect(n).to eq vector(Math.sqrt(3.0)/3.0,Math.sqrt(3.0)/3.0,Math.sqrt(3.0)/3.0)
      end

    end

    describe "for a transformed sphere" do
      let(s) { sphere() }

      it "computes translated normals" do
        t = translation(0.0, 1.0, 0.0)
        s.transform = t
        n = s.normal_at(point(0.0, 1.70711, -0.70711))

	expect(n.approximate?(vector(0.0, 0.70711, -0.70711))).to be true
      end

      it "computes scaled and rotated normals" do
        t = scaling(1.0, 0.5, 1.0) * rotation_z(Math::PI / 5.0)
        s.transform = t
        n = s.normal_at(point(0.0, Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0))

	expect(n.approximate?(vector(0.0, 0.97014, -0.24254))).to be true
      end
    end
  end
end

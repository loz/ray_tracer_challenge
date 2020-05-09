require "./spec_helper"

Spectator.describe Group do
  let(g) { group() }

  it "is empty by default" do
    expect(g.empty?).to be true
  end

  it "has identity transform" do
    expect(g.transform).to eq identity_matrix
  end

  describe "adding a child to a group" do
    let(s) { test_shape() }
    
    before_each do
      g << s
    end

    it "is no longer empty" do
      expect(g.empty?).to be false
    end

    it "is the parent of the added item" do
      expect(s.parent).to be g
    end
  end

  describe "intersecting with a non-empty group" do
    let(g) { group() }
    let(s1) { sphere() }
    let(s2) { sphere() }
    let(s3) { sphere() }
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }

    let(xs) { g.intersect(r) }

    before_each do
      s2.transform = translation(0.0, 0.0, -3.0)
      s3.transform = translation(5.0, 0.0, 0.0)
      g << s1
      g << s2
      g << s3
    end

    it "intersects based on the children" do
      expect(xs.size).to eq 4
      expect(xs[0].object).to eq s2
      expect(xs[1].object).to eq s2
      expect(xs[2].object).to eq s1
      expect(xs[3].object).to eq s1
    end
  end

  describe "intersecting a transformed group" do
    let(g) { group() }
    let(s) { sphere() }
    let(r) { ray(point(10.0, 0.0, -10.0), vector(0.0, 0.0, 1.0)) }

    let(xs) { g.intersect(r) }

    before_each do
      g.transform = scaling(2.0, 2.0, 2.0)
      s.transform = translation(5.0, 0.0, 0.0)
      g << s
    end

    it "works on the transforms of children too" do
      expect(xs.size).to eq 2

    end
  end

  describe "Bounds" do
    let(g) { group() }
    let(s1) { cube() }
    let(s2) { cube() }

    before_each do
      s1.transform = translation(-11.0,-10.0,-13.0)
      s2.transform = translation( 15.0, 12.0, 18.0)
      g << s1
      g << s2
    end

    it "surounds objects within group, including translations" do
      bounds = g.bounds
      expect(bounds.min).to eq point(-12.0,-11.0,-14.0)
      expect(bounds.max).to eq point( 16.0, 13.0, 19.0)
    end

    describe "when rotations cause bounding box to widen" do
      before_each do
        s1.transform = s1.transform *
                       rotation_z(Math::PI/4.0)
        s2.transform = s2.transform *
                       rotation_x(Math::PI/4.0)
        g.calc_bounds!
      end

      it "accounts for all 8 corners in the group" do
        bounds = g.bounds
        rt2 = Math.sqrt(2.0)
        expect(bounds.min).to eq point(-11.0-rt2,-10.0-rt2,-14.0)
        expect(bounds.max).to eq point( 16.0,     12.0+rt2, 18.0+rt2)
      end
    end
  end

end

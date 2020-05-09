Spectator.describe Plane do
  let(p) { plane() }
  let(n) { vector(0.0, 1.0, 0.0) }

  describe "Normal" do
    it "is constant everywhere" do
      expect(p.normal_at(point(0.0, 0.0, 0.0))).to eq n
      expect(p.normal_at(point(10.0, 0.0, -10.0))).to eq n
      expect(p.normal_at(point(5.0, 0.0, 150.0))).to eq n
    end
  end

  describe "Bounds" do
    it "is infinte in x and z, with no y" do
      bounds = p.bounds
      expect(bounds.min).to eq point(-Float64::INFINITY,0.0,-Float64::INFINITY)
      expect(bounds.max).to eq point( Float64::INFINITY,0.0, Float64::INFINITY)
    end
  end

  describe "Intersecting" do
    let(xs) { p.intersect(r) }

    describe "when parallel to plane" do
      let(r) { ray(point(0.0, 10.0, 0.0), vector(0.0, 0.0, 1.0)) }

      it "does not intersect" do
	expect(xs.size).to eq 0
      end
    end

    describe "when coplanar ray" do
      let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 1.0)) }

      it "does not intersect" do
	expect(xs.size).to eq 0
      end
    end

    describe "intesecting from above" do
      let(r) { ray(point(0.0, 1.0, 0.0), vector(0.0, -1.0, 0.0)) }

      it "intersects" do
	expect(xs.size).to eq 1
	expect(xs[0].t).to eq 1.0
	expect(xs[0].object).to eq p
      end
    end

    describe "intersecting from below" do
      let(r) { ray(point(0.0, -1.0, 0.0), vector(0.0, 1.0, 0.0)) }

      it "intersects" do
	expect(xs.size).to eq 1
	expect(xs[0].t).to eq 1.0
	expect(xs[0].object).to eq p
      end
    end
  end
end

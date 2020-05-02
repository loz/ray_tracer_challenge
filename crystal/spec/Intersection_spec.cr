require "./spec_helper"

Spectator.describe Intersection do
  describe "Intersection encapsulation" do
    let(s) { sphere() }
    let(i) { intersection(3.5, s) }
    
    it "includes time(t) and object hit" do
      expect(i.t).to eq 3.5
      expect(i.object).to eq s
    end
  end

  describe "Intersections include agregates" do
    let(s) { sphere() }
    let(i1) { intersection(1.0, s) }
    let(i2) { intersection(2.0, s) }

    it "includes a set" do
      xs = intersections(i1, i2)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq 1.0
      expect(xs[1].t).to eq 2.0
    end
  end

  describe "Hits" do
    describe "when all intersections are positive" do
      let(s) { sphere() }
      let(i1) { intersection(1.0, s) }
      let(i2) { intersection(2.0, s) }
      let(xs) { intersections(i2, i1) }

      it "is the smallest time" do
        expect(xs.hit).to eq (i1)
      end
    end

    describe "when some intersections are negative" do
      let(s) { sphere() }
      let(i1) { intersection(-1.0, s) }
      let(i2) { intersection(1.0, s) }
      let(xs) { intersections(i2, i1) }

      it "is the smallest non negative time" do
        expect(xs.hit).to eq (i2)
      end
    end

    describe "when all intersections are negative" do
      let(s) { sphere() }
      let(i1) { intersection(-2.0, s) }
      let(i2) { intersection(-1.0, s) }
      let(xs) { intersections(i2, i1) }

      it "is null" do
        expect(xs.hit.null?).to eq true
      end
    end

    describe "when in random order" do
      let(s) { sphere() }
      let(i1) { intersection( 5.0, s) }
      let(i2) { intersection( 7.0, s) }
      let(i3) { intersection(-3.0, s) }
      let(i4) { intersection( 2.0, s) }

      let(xs) { intersections(i1, i2, i3, i4) }

      it "is always the lowest non-negative intersection" do
        expect(xs.hit).to eq i4
      end
    end
  end

  describe "preparing computations" do
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }
    let(i) { intersection(4.0, s) }
    let(comps) { i.prepare_computations(r) }

    it "has time of intersection" do
      expect(comps.t).to eq i.t
    end

    it "has object of intersection" do
      expect(comps.object).to eq i.object
    end

    it "has point relative to position" do
      expect(comps.point).to eq point(0.0, 0.0, -1.0)
    end

    it "has eyev relative to direction of ray" do
      expect(comps.eyev).to eq vector(0.0, 0.0, -1.0)
    end

    it "has normalv relative to normal of object + point" do
      expect(comps.normalv).to eq vector(0.0, 0.0, -1.0)
    end

    describe "reflection vector" do
      let(s) { plane() }
      let(r) { ray(point(0.0, 1.0, -1.0), vector(0.0, -Math.sqrt(2)/2.0, Math.sqrt(2)/2.0)) }
      let(i) { intersection(Math.sqrt(2.0), s) }

      it "is included" do
        comps = i.prepare_computations(r)
        expect(comps.reflectv.approximate?(vector(0.0, Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0))).to be true
      end
    end

    describe "when occuring on the outside" do
      it "is not inside" do
        expect(comps.inside?).to eq false
      end
    end

    describe "when occuring on the inside" do
      let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 1.0)) }

      it "is inside" do
        expect(comps.inside?).to eq true
      end

      it "has inverted normal" do
        expect(comps.normalv).to eq vector(0.0, 0.0, -1.0)
      end
    end
  end
end

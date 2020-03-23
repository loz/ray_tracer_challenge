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
end

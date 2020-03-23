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
end

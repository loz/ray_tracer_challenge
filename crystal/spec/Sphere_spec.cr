require "./spec_helper"

Spectator.describe Sphere do
  describe "A ray intersecting a sphere" do
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "does so at two time points" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0]).to eq 4.0
      expect(xs[1]).to eq 6.0
    end
  end

  describe "A ray intersecting a sphere at a tangent" do
    let(r) { ray(point(0.0, 1.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "does so at two co-incident time points" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0]).to eq 5.0
      expect(xs[1]).to eq 5.0
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

      expect(xs[0]).to eq -1.0
      expect(xs[1]).to eq  1.0
    end
  end

  describe "A ray originating behind a sphere" do
    let(r) { ray(point(0.0, 0.0, 5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }

    it "intersects with two negative times(t)" do
      xs = s.intersect(r)
      expect(xs.size).to eq 2

      expect(xs[0]).to eq -6.0
      expect(xs[1]).to eq -4.0
    end
  end
end

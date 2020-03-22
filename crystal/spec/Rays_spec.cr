require "./spec_helper"

Spectator.describe Rays do
  describe "Creating and querying a ray" do
    let(origin) { point(1.0, 2.0, 3.0) }
    let(direction) { vector(4.0, 5.0, 6.0) }

    it "has origin and direction" do
       r = ray(origin, direction)

       expect(r.origin).to eq origin
       expect(r.direction).to eq direction
    end
  end

  describe "Computing a point from a distance" do
    let(r) { ray(point(2.0, 3.0, 4.0), vector(1.0, 0.0, 0.0)) }

    it "has position based on how far ray traveled in time(t)" do
      expect(r.position(0.0)).to eq point(2.0, 3.0, 4.0)
      expect(r.position(1.0)).to eq point(3.0, 3.0, 4.0)
      expect(r.position(-1.0)).to eq point(1.0, 3.0, 4.0)
      expect(r.position(2.5)).to eq point(4.5, 3.0, 4.0)
    end
  end
end

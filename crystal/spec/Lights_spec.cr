require "./spec_helper"

Spectator.describe Lights do
  describe "point properties" do
    let(i) { color(1.0, 1.0, 1.0) }
    let(p) { point(0.0, 0.0, 0.0) }

    it "has a position and intensity" do
      l = point_light(p, i)

      expect(l.position).to eq p
      expect(l.intensity).to eq i
    end
  end
end

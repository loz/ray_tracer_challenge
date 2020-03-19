require "./spec_helper"

Spectator.describe RTuple do
  describe "w value of 1.0" do
    let(a) { RTuple.new(4.3, -5.1, 3.1, 1.0) }

    it "has given values" do
    	expect(a.x).to eq(4.3)
    	expect(a.y).to eq(-5.1)
    	expect(a.z).to eq(3.1)
    	expect(a.w).to eq(1.0)
    end

    it "is a point" do
       expect(a.point?).to be_true
    end

    it "is not a vector" do
       expect(a.vector?).to be_false
    end
  end

  describe "w value of 0.0" do
    let(a) { RTuple.new(4.3, -5.1, 3.1, 0.0) }

    it "is not a point" do
       expect(a.point?).to be_false
    end

    it "is a vector" do
       expect(a.vector?).to be_true
    end
  end
end

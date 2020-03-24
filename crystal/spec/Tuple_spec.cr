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

  describe "Adding" do
    let(a1) { RTuple.new(3.0, -2.0, 5.0, 1.0) }
    let(a2) { RTuple.new(-2.0, 3.0, 1.0, 0.0) }

    it "adds the components" do
    	expect(a1 + a2).to eq(RTuple.new(1.0, 1.0, 6.0, 1.0))
    end
  end

  describe "Subtracting two points" do
    let(p1) { point(3.0, 2.0, 1.0) }
    let(p2) { point(5.0, 6.0, 7.0) }

    it "produces the vector between" do
    	expect(p1 - p2).to eq(vector(-2.0, -4.0, -6.0))
    end
  end

  describe "Subtracting vector from a point" do
    let(p) { point(3.0, 2.0, 1.0) }
    let(v) { vector(5.0, 6.0, 7.0) }

    it "produces the transformed point" do
    	expect(p - v).to eq(point(-2.0, -4.0, -6.0))
    end
  end

  describe "Subtracting from zero vector" do
    let(zero) { vector(0.0, 0.0, 0.0) }
    let(v) { vector(1.0, -2.0, 3.0) }

    it "produces the negative vector" do
    	expect(zero - v).to eq(vector(-1.0, 2.0, -3.0))
    	expect(-v).to eq(vector(-1.0, 2.0, -3.0))
    end
  end

  describe "Multiplying a tuple by a scalar" do
    let(a) { RTuple.new(1.0, -2.0, 3.0, -4.0) }
    
    it "scales the elements" do
       expect(a * 3.5).to eq(RTuple.new(3.5, -7.0, 10.5, -14.0))
    end
  end

  describe "Multiplying a tuple by a fraction" do
    let(a) { RTuple.new(1.0, -2.0, 3.0, -4.0) }
    
    it "scales the elements" do
       expect(a * 0.5).to eq(RTuple.new(0.5, -1.0, 1.5, -2.0))
    end
  end

  describe "Dividing a tuple by a scalar" do
    let(a) { RTuple.new(1.0, -2.0, 3.0, -4.0) }
    
    it "scales the elements" do
       expect(a / 2.0).to eq(RTuple.new(0.5, -1.0, 1.5, -2.0))
    end
  end

  describe "Vector Magnitude" do
    it "has magnitude of single element when all others zero" do
       expect(vector(1.0,0.0,0.0).magnitude).to eq 1.0
       expect(vector(0.0,1.0,0.0).magnitude).to eq 1.0
       expect(vector(0.0,0.0,1.0).magnitude).to eq 1.0
    end

    it "has magnitude according to pythagorus' theorum" do
       expect(vector(1.0,2.0,3.0).magnitude).to eq Math.sqrt(14.0)
       expect(vector(-1.0,-2.0,-3.0).magnitude).to eq Math.sqrt(14.0)
    end
  end

  describe "Normalizing a Vector" do
    let(v1) { vector(4.0, 0.0, 0.0) }
    let(v2) { vector(1.0, 2.0, 3.0) }

    it "shrinks all components by the magnitude" do
    	expect(v1.normalize).to eq(vector(1.0, 0.0, 0.0))
	expect(v2.normalize.approximate?(vector(0.26726, 0.53452, 0.80178))).to be_true
    end

    it "results in a vector with magnitude of 1" do
    	expect(v1.normalize.magnitude).to eq(1.0)
	expect(v2.normalize.magnitude).to eq(1.0)
    end
  end

  describe "Dot Product" do 
    let(a) { vector(1.0, 2.0, 3.0) }
    let(b) { vector(2.0, 3.0, 4.0) }

    it "sum components multiplied" do
      expect(a.dot(b)).to eq(20.0)
    end
  end

  describe "Cross Product" do
    let(a) { vector(1.0, 2.0, 3.0) }
    let(b) { vector(2.0, 3.0, 4.0) }

    it "sum computes cross product" do
      expect(a.cross(b)).to eq(vector(-1.0, 2.0, -1.0))
      expect(b.cross(a)).to eq(vector(1.0, -2.0,  1.0))
    end
  end

  describe "Reflecting a vector" do
    describe "approaching at 45degree" do
      let(v) { vector( 1.0,-1.0, 0.0) }
      let(n) { vector( 0.0, 1.0, 0.0) }
      let(r) { v.reflect(n) }

      it "reflects at 45 degrees in other direction" do
        expect(r).to eq vector(1.0, 1.0, 0.0)
      end
    end

    describe "off a slanted surface" do
      let(v) { vector( 0.0,-1.0, 0.0) }
      let(n) { vector(Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0, 0.0) }
      let(r) { v.reflect(n) }

      it "reflects at degrees from normal in other direction" do
        expect(r.approximate?(vector(1.0, 0.0, 0.0))).to eq true
      end

    end
  end
end

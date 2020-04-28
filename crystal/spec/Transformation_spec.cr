require "./spec_helper"

Spectator.describe Transformation do
  describe "Translation" do
    describe "Multiplying by translation matrix" do
      let(t) { translation(5.0, -3.0, 2.0) }
      let(p) { point(-3.0, 4.0, 5.0) }

      it "transforms the point" do
        expect(t * p).to eq(point(2.0, 1.0, 7.0))
      end
    end

    describe "Multiplying by inverse translation matrix" do
      let(t) { translation(5.0, -3.0, 2.0) }
      let(i) { t.inverse }
      let(p) { point(-3.0, 4.0, 5.0) }

      it "transforms the point in opposite direction" do
        expect(i * p).to eq(point(-8.0, 7.0, 3.0))
      end
    end

    describe "Translation does not affect" do
      let(t) { translation(5.0, -3.0, 2.0) }
      let(v) { vector(-3.0, 4.0, 5.0) }

      it "vectors" do
        expect(t * v).to eq(v)
      end
    end
  end

  describe "Scaling" do
    describe "scaling a matrix on a point" do
      let(t) { scaling(2.0, 3.0, 4.0) }
      let(p) { point(-4.0, 6.0, 8.0) }

      it "scales point relative to origin" do
        expect(t * p).to eq point(-8.0, 18.0, 32.0)
      end
    end

    describe "scaling a matrix on a vextor" do
      let(t) { scaling(2.0, 3.0, 4.0) }
      let(v) { vector(-4.0, 6.0, 8.0) }

      it "scales vector relative to origin" do
        expect(t * v).to eq vector(-8.0, 18.0, 32.0)
      end
    end

    describe "scaling by an inverse matrix" do
      let(t) { scaling(2.0, 3.0, 4.0) }
      let(v) { vector(-4.0, 6.0, 8.0) }
      let(i) { t.inverse }

      it "scales vector relative to origin" do
        expect(i * v).to eq vector(-2.0, 2.0, 2.0)
      end
    end

    describe "scaling by a negative value" do
      let(t) { scaling(-1.0, 1.0, 1.0) }
      let(p) { point( 2.0, 3.0, 4.0) }

      it "is reflection" do
        expect(t * p).to eq point(-2.0, 3.0, 4.0)
      end
    end
  end

  describe "Rotation" do
    describe "around x axis" do
      let(p) { point(0.0, 1.0, 0.0) }
      let(half_quarter) { rotation_x(Math::PI / 4.0) }
      let(full_quarter) { rotation_x(Math::PI / 2.0) }

      it "rotates accordingly" do
        expect((half_quarter * p).approximate?(point(0.0, Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0))).to eq true

        expect((full_quarter * p).approximate?(point(0.0, 0.0, 1.0))).to eq true
      end
    end

    describe "inverse of x axis" do
      let(p) { point(0.0, 1.0, 0.0) }
      let(half_quarter) { rotation_x(Math::PI / 4.0) }
      let(inv) { half_quarter.inverse }

      it "rotates in opposite direction" do
        expect((inv * p).approximate?(point(0.0, Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0))).to eq true
      end
    end

    describe "around y axis" do
      let(p) { point(0.0, 0.0, 1.0) }
      let(half_quarter) { rotation_y(Math::PI / 4.0) }
      let(full_quarter) { rotation_y(Math::PI / 2.0) }

      it "rotates accordingly" do
        expect((half_quarter * p).approximate?(point(Math.sqrt(2.0)/2.0, 0.0, Math.sqrt(2.0)/2.0))).to eq true

        expect((full_quarter * p).approximate?(point(1.0, 0.0, 0.0))).to eq true
      end
    end

    describe "around z axis" do
      let(p) { point(0.0, 1.0, 0.0) }
      let(half_quarter) { rotation_z(Math::PI / 4.0) }
      let(full_quarter) { rotation_z(Math::PI / 2.0) }

      it "rotates accordingly" do
        expect((half_quarter * p).approximate?(point(0.0 - Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0, 0.0))).to eq true

        expect((full_quarter * p).approximate?(point(-1.0, 0.0, 0.0))).to eq true
      end
    end
  end

  describe "Shearing" do
    let(p) { point(2.0, 3.0, 4.0) }

    describe "x in proportion to y" do
      let(t) { shearing(1.0, 0.0, 0.0, 0.0, 0.0, 0.0) }
      
      it "add 1y to x" do
        expect((t * p).approximate?(point(5.0, 3.0, 4.0))).to eq true
      end
    end

    describe "x in proportion to z" do
      let(t) { shearing(0.0, 1.0, 0.0, 0.0, 0.0, 0.0) }
      
      it "add 1z to x" do
        expect((t * p).approximate?(point(6.0, 3.0, 4.0))).to eq true
      end
    end

    describe "y in proportion to x" do
      let(t) { shearing(0.0, 0.0, 1.0, 0.0, 0.0, 0.0) }
      
      it "add 1x to y" do
        expect((t * p).approximate?(point(2.0, 5.0, 4.0))).to eq true
      end
    end

    describe "y in proportion to z" do
      let(t) { shearing(0.0, 0.0, 0.0, 1.0, 0.0, 0.0) }
      
      it "add 1z to y" do
        expect((t * p).approximate?(point(2.0, 7.0, 4.0))).to eq true
      end
    end

    describe "z in proportion to x" do
      let(t) { shearing(0.0, 0.0, 0.0, 0.0, 1.0, 0.0) }
      
      it "add 1x to z" do
        expect((t * p).approximate?(point(2.0, 3.0, 6.0))).to eq true
      end
    end

    describe "z in proportion to y" do
      let(t) { shearing(0.0, 0.0, 0.0, 0.0, 0.0, 1.0) }
      
      it "add 1y to z" do
        expect((t * p).approximate?(point(2.0, 3.0, 7.0))).to eq true
      end
    end
  end

  describe "Combining transformations" do
    let(p) { point(1.0, 0.0, 1.0) }
    let(a) { rotation_x(Math::PI / 2.0) }
    let(b) { scaling(5.0, 5.0, 5.0) }
    let(c) { translation(10.0, 5.0, 7.0) }

    it "can be in sequence" do
      p2 = a * p
      expect(p2.approximate?(point( 1.0,-1.0, 0.0))).to eq true

      p3 = b * p2
      expect(p3.approximate?(point(5.0, -5.0, 0.0))).to eq true

      p4 = c * p3
      expect(p4.approximate?(point(15.0, 0.0, 7.0))).to eq true
    end

    it "can be chained - in reverse order" do
      t = c * b * a
      p4 = t * p
      expect(p4.approximate?(point(15.0, 0.0, 7.0))).to eq true
    end

    it "can be expressed in method chains" do
      t = identity_matrix.
          rotate_x(Math::PI / 2.0).
          scale(5.0, 5.0, 5.0).
          translate(10.0, 5.0, 7.0)

      p4 = t * p
      expect(p4.approximate?(point(15.0, 0.0, 7.0))).to eq true
    end
  end

  describe "View Transformation" do
    describe "has a dfault orientation" do
      let(from) { point(0.0, 0.0, 0.0) }
      let(to) { point(0.0, 0.0, -1.0) }
      let(up) { vector(0.0, 1.0, 0.0) }

      it "has the identity matrix" do
        t = view_transform(from, to, up)

	expect(t).to eq identity_matrix
      end
    end

    describe "looking in positive z" do
      let(from) { point(0.0, 0.0, 0.0) }
      let(to) { point(0.0, 0.0, 1.0) }
      let(up) { vector(0.0, 1.0, 0.0) }

      it "has reflected view" do
        t = view_transform(from, to, up)

	expect(t).to eq scaling(-1.0, 1.0, -1.0)
      end
    end

    describe "moving the world" do
      let(from) { point(0.0, 0.0, 8.0) }
      let(to) { point(0.0, 0.0, 0.0) }
      let(up) { vector(0.0, 1.0, 0.0) }

      it "has translated view" do
        t = view_transform(from, to, up)

	expect(t).to eq translation(0.0, 0.0, -8.0)
      end
    end

    describe "an arbitrary view transformation" do
      let(from) { point(1.0, 3.0, 2.0) }
      let(to) { point(4.0, -2.0, 8.0) }
      let(up) { vector(1.0, 1.0, 0.0) }
  
      it "transformed matrix" do
        t = view_transform(from, to, up)

	expect(t.approx(matrix({
	  {-0.50709, 0.50709, 0.67612,-2.36643},
	  { 0.76772, 0.60609, 0.12122,-2.82843},
	  {-0.35857, 0.59761,-0.71714, 0.00000},
	  { 0.00000, 0.00000, 0.00000, 1.00000}
	}))).to be true
      end
    end
  end
end

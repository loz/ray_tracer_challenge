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
        expect((half_quarter * p).aproximate?(point(0.0, Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0))).to eq true

        expect((full_quarter * p).aproximate?(point(0.0, 0.0, 1.0))).to eq true
      end
    end

    describe "inverse of x axis" do
      let(p) { point(0.0, 1.0, 0.0) }
      let(half_quarter) { rotation_x(Math::PI / 4.0) }
      let(inv) { half_quarter.inverse }

      it "rotates in opposite direction" do
        expect((inv * p).aproximate?(point(0.0, Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0))).to eq true
      end
    end

    describe "around y axis" do
      let(p) { point(0.0, 0.0, 1.0) }
      let(half_quarter) { rotation_y(Math::PI / 4.0) }
      let(full_quarter) { rotation_y(Math::PI / 2.0) }

      it "rotates accordingly" do
        expect((half_quarter * p).aproximate?(point(Math.sqrt(2.0)/2.0, 0.0, Math.sqrt(2.0)/2.0))).to eq true

        expect((full_quarter * p).aproximate?(point(1.0, 0.0, 0.0))).to eq true
      end
    end

    describe "around z axis" do
      let(p) { point(0.0, 1.0, 0.0) }
      let(half_quarter) { rotation_z(Math::PI / 4.0) }
      let(full_quarter) { rotation_z(Math::PI / 2.0) }

      it "rotates accordingly" do
        expect((half_quarter * p).aproximate?(point(0.0 - Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0, 0.0))).to eq true

        expect((full_quarter * p).aproximate?(point(-1.0, 0.0, 0.0))).to eq true
      end
    end
  end

  describe "Shearing" do
    let(p) { point(2.0, 3.0, 4.0) }

    describe "x in proportion to y" do
      let(t) { shearing(1.0, 0.0, 0.0, 0.0, 0.0, 0.0) }
      
      it "add 1y to x" do
        expect((t * p).aproximate?(point(5.0, 3.0, 4.0))).to eq true
      end
    end

    describe "x in proportion to z" do
      let(t) { shearing(0.0, 1.0, 0.0, 0.0, 0.0, 0.0) }
      
      it "add 1z to x" do
        expect((t * p).aproximate?(point(6.0, 3.0, 4.0))).to eq true
      end
    end

    describe "y in proportion to x" do
      let(t) { shearing(0.0, 0.0, 1.0, 0.0, 0.0, 0.0) }
      
      it "add 1x to y" do
        expect((t * p).aproximate?(point(2.0, 5.0, 4.0))).to eq true
      end
    end

    describe "y in proportion to z" do
      let(t) { shearing(0.0, 0.0, 0.0, 1.0, 0.0, 0.0) }
      
      it "add 1z to y" do
        expect((t * p).aproximate?(point(2.0, 7.0, 4.0))).to eq true
      end
    end

    describe "z in proportion to x" do
      let(t) { shearing(0.0, 0.0, 0.0, 0.0, 1.0, 0.0) }
      
      it "add 1x to z" do
        expect((t * p).aproximate?(point(2.0, 3.0, 6.0))).to eq true
      end
    end

    describe "z in proportion to y" do
      let(t) { shearing(0.0, 0.0, 0.0, 0.0, 0.0, 1.0) }
      
      it "add 1y to z" do
        expect((t * p).aproximate?(point(2.0, 3.0, 7.0))).to eq true
      end
    end
  end
end

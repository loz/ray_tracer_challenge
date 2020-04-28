require "./spec_helper"

Spectator.describe Camera do
  describe "Constructing" do
    let(hsize) { 160 }
    let(vsize) { 120 }
    let(fov) { Math::PI / 2.0 }
    let(c) { camera(hsize, vsize, fov) }

    it "has given parameters" do
      expect(c.hsize).to eq 160
      expect(c.vsize).to eq 120
      expect(c.field_of_view).to eq fov
    end

    it "has identity transform" do
      expect(c.transform).to eq identity_matrix
    end
  end

  describe "Pixel size" do
    describe "horizontal" do
      let(c) { camera(200, 125, Math::PI/2.0) }

      it "has size of 0.01" do
        expect(approximate(c.pixel_size,0.01)).to be true
      end
    end

    describe "vertical" do
      let(c) { camera(125, 200, Math::PI/2.0) }

      it "has size of 0.01" do
        expect(approximate(c.pixel_size,0.01)).to be true
      end
    end
  end

  describe "Ray for canvas" do
    let(c) { camera(201, 101, Math::PI / 2.0) }

    it "calculates for center correctly" do
      r = c.ray_for_pixel(100, 50)
      expect(r.origin).to eq point(0.0, 0.0, 0.0)
      expect(r.direction.approximate?(vector(0.0, 0.0, -1.0))).to be true
    end

    it "calculates for corner correctly" do
      r = c.ray_for_pixel(0, 0)
      expect(r.origin).to eq point(0.0, 0.0, 0.0)
      expect(r.direction.approximate?(vector(0.66519, 0.33259, -0.66851))).to be true
    end

    it "calculates for transformed camera" do
      c.transform = rotation_y(Math::PI / 4.0) * translation(0.0, -2.0, 5.0)
      r = c.ray_for_pixel(100, 50)
      expect(r.origin).to eq point(0.0, 2.0, -5.0)
      expect(r.direction.approximate?(vector(Math.sqrt(2.0)/2.0, 0.0, -Math.sqrt(2.0)/2.0))).to be true
    end
  end

  describe "Rendering" do
    let(w) { default_world() }
    let(c) { camera(11, 11, Math::PI / 2.0) }
    let(from) { point(0.0, 0.0, -5.0) }
    let(to) { point(0.0, 0.0, 0.0) }
    let(up) { vector(0.0, 1.0, 0.0) }
    
    it "renders pixels" do
      c.transform = view_transform(from, to, up)
      image = c.render(w)

      expect(image.pixel_at(5,5).approximate?(color(0.38066, 0.47583, 0.2855))).to be true
    end
  end
end

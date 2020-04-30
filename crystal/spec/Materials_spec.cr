require "./spec_helper"

Spectator.describe Materials do
  describe "Default" do
    let(m) { material() }
    it "has ambient, diffuse, specular and shinyness properties" do
      expect(m.color).to eq color(1.0, 1.0, 1.0)

      expect(m.ambient).to eq 0.1
      expect(m.diffuse).to eq 0.9
      expect(m.specular).to eq 0.9
      expect(m.shininess).to eq 200.0
    end
  end

  describe "Effects" do
    let(m) { material() }
    let(position) { point(0.0, 0.0, 0.0) }

    describe "Lighting with eye between the light and the surface" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(light, position, eyev, normalv)

	expect(result).to eq color(1.9, 1.9, 1.9)
      end
    end

    describe "Lighting with eye between the light and the surface, offset 45degrees" do
      let(eyev) { vector(0.0, Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(light, position, eyev, normalv)

	expect(result.approximate?(color(1.0, 1.0, 1.0))).to be true
      end
    end

    describe "Lighting with eye opposite the surface, light offset 45degrees" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 10.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(light, position, eyev, normalv)
	
	expect(result.approximate?(color(0.7364, 0.7364, 0.7364))).to be true
      end
    end

    describe "Lighting with eye in path of reflection vector" do
      let(eyev) { vector(0.0, 0.0 - Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 10.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(light, position, eyev, normalv)

	expect(result.approximate?(color(1.6364, 1.6364, 1.6364))).to be true
      end
    end

    describe "Lighting with light behind the surface" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, 10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting ambient color" do
        result = m.lighting(light, position, eyev, normalv)

	expect(result.approximate?(color(0.1, 0.1, 0.1))).to be true
      end
    end

    describe "Lighting with surface in shadow" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0)) }
      let(in_shadow) { true }

      it "has a resulting color" do
        result = m.lighting(light, position, eyev, normalv, in_shadow)

	expect(result.approximate?(color(0.1, 0.1, 0.1))).to be true
      end
    end
  end
end
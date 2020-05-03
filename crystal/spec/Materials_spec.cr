require "./spec_helper"

Spectator.describe Materials do
  let(object) { sphere }
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
        result = m.lighting(object, light, position, eyev, normalv)

	expect(result).to eq color(1.9, 1.9, 1.9)
      end
    end

    describe "Lighting with eye between the light and the surface, offset 45degrees" do
      let(eyev) { vector(0.0, Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(object, light, position, eyev, normalv)

	expect(result.approximate?(color(1.0, 1.0, 1.0))).to be true
      end
    end

    describe "Lighting with eye opposite the surface, light offset 45degrees" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 10.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(object, light, position, eyev, normalv)
	
	expect(result.approximate?(color(0.7364, 0.7364, 0.7364))).to be true
      end
    end

    describe "Lighting with eye in path of reflection vector" do
      let(eyev) { vector(0.0, 0.0 - Math.sqrt(2.0)/2.0, 0.0 - Math.sqrt(2.0)/2.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 10.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting color" do
        result = m.lighting(object, light, position, eyev, normalv)

	expect(result.approximate?(color(1.6364, 1.6364, 1.6364))).to be true
      end
    end

    describe "Lighting with light behind the surface" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, 10.0), color(1.0, 1.0, 1.0)) }

      it "has a resulting ambient color" do
        result = m.lighting(object, light, position, eyev, normalv)

	expect(result.approximate?(color(0.1, 0.1, 0.1))).to be true
      end
    end

    describe "Lighting with surface in shadow" do
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0)) }
      let(in_shadow) { true }

      it "has a resulting color" do
        result = m.lighting(object, light, position, eyev, normalv, in_shadow)

	expect(result.approximate?(color(0.1, 0.1, 0.1))).to be true
      end
    end
    
    describe "Lighting with a Pattern" do
      let(p) { stripe_pattern(white, black) }
      let(eyev) { vector(0.0, 0.0, -1.0) }
      let(normalv) { vector(0.0, 0.0, -1.0) }
      let(light) { point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0)) }

      it "accounts for material pattern color" do
        m.pattern = p
	      m.ambient = 1.0
	      m.diffuse = 0.0
	      m.specular = 0.0

	      c1 = m.lighting(object, light, point(0.9, 0.0, 0.0), eyev, normalv, false)
	      c2 = m.lighting(object, light, point(1.1, 0.0, 0.0), eyev, normalv, false)

	      expect(c1).to eq white
	      expect(c2).to eq black
      end
    end
  end

  describe "Reflectivity" do
    let(m) { material() }

    it "has none by default" do
      expect(m.reflective).to eq 0.0
    end
  end

  describe "Transparency and Refractive Index" do
    let(m) { material() }

    it "is not transparent by default" do
      expect(m.transparency).to eq 0.0
    end

    it "has index of 1.0 by default (a vacuum)" do
      expect(m.refractive_index).to eq 1.0
    end
  end
end

require "./spec_helper"

Spectator.describe World do
  describe "Creating A World" do
    let(w) { world() }

    it "contains no objects" do
      expect(w.objects.size).to eq 0
    end
  end

  describe "The Default World" do
    let(w) { default_world() }
    let(light) { point_light(point(-10.0, 10.0, -10.0), color(1.0, 1.0, 1.0)) }
    let(s1) do 
      s = sphere()
      s.material.color = color(0.8, 1.0, 0.6)
      s.material.diffuse = 0.7
      s.material.specular = 0.2
      s
    end
    let(s2) do
      s = sphere()
      s.transform = scaling(0.5, 0.5, 0.5)
      s
    end

    it "has a light" do
      expect(w.light).to eq light
    end

    it "contains sphere 1" do
      expect(w.objects).to contain s1
    end

    it "contains sphere 2" do
      expect(w.objects).to contain s2
    end
  end

  describe "intersecting with a ray" do
    let(w) { default_world() }
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }

    let(xs) { w.intersect(r) }

    it "intersects with the objects in the world" do
      expect(xs.size).to eq 4

      expect(xs[0].t).to eq 4.0
      expect(xs[1].t).to eq 4.5
      expect(xs[2].t).to eq 5.5
      expect(xs[3].t).to eq 6.0
    end
  end

  describe "Shading an intersection" do
    let(w) { default_world() }
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }

    let(s) { w.objects.first }
    let(i) { intersection(4.0, s) }

    let(comps) { i.prepare_computations(r) }

    it "calculates the color for the hit" do
      c = w.shade_hit(comps)
      expect(c.approximate?(color(0.38066, 0.47583, 0.2855))).to be true
    end

  end
end

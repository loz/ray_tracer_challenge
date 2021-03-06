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

    describe "when intersecting a shadow" do
      let(w) { world }
      let(r) { ray(point(0.0, 0.0, 5.0), vector(0.0, 0.0, 1.0)) }


      it "counts as shaded" do
        w.light = point_light(point(0.0, 0.0, -10.0), color(1.0, 1.0, 1.0))
	      s1 = sphere()
	      w.objects << s1
	      s2 = sphere()
	      s2.transform = translation(0.0, 0.0, 10.0)
	      w.objects << s2
	      i = intersection(4.0, s2)

	      comps = i.prepare_computations(r)
	      c = w.shade_hit(comps)
	      expect(c.approximate?(color(0.1, 0.1, 0.1))).to be true
      end
    end

  end

  describe "Color seen by ray in world" do
    let(w) { default_world() }

    describe "when ray misses object" do
      let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 1.0, 0.0)) }

      it "is black" do
        c = w.color_at(r)
	      expect(c).to eq black
      end
    end

    describe "when ray hits object" do
      let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }

      it "is the shaded color of the object" do
      	c = w.color_at(r)
      	expect(c.approximate?(color(0.38066, 0.47583, 0.2855))).to be true
      end
    end

    describe "when the intersection is behind the ray" do
      let(outer) { w.objects[0] }
      let(inner) { w.objects[1] }
      let(r) { ray(point(0.0, 0.0, 0.75), vector(0.0, 0.0, -1.0)) }

      it "is material color" do
        outer.material.ambient = 1.0
	      inner.material.ambient = 1.0

	      c = w.color_at(r)
	      expect(c).to eq inner.material.color
      end
    end
  end

  describe "Calculating Shadows" do
    let(w) { default_world }

    describe "when nothing collinear to point and light" do
      let(p) { point(0.0, 10.0, 0.0) }

      it "is not in shadow" do
        expect(w.is_shadowed?(p)).to be false
      end
    end

    describe "when object betwen point and the light" do
      let(p) { point(10.0, -10.0, 10.0) }

      it "is in shadow" do
        expect(w.is_shadowed?(p)).to be true
      end
    end

    describe "when the object has material set to no-shadow" do
      let(p) { point(10.0, -10.0, 10.0) }
      before_each do
        o1 = w.objects[0]
        o2 = w.objects[1]
        o1.material.shadows = false
        o2.material.shadows = false
      end

      it "is in shadow" do
        expect(w.is_shadowed?(p)).to be false
      end
    end

    describe "when object behind the light" do
      let(p) { point(-20.0, 20.0, -20.0) }

      it "is not in shadow" do
        expect(w.is_shadowed?(p)).to be false
      end
    end
    describe "when object behind the point" do
      let(p) { point(-2.0, 2.0, -2.0) }

      it "is not in shadow" do
        expect(w.is_shadowed?(p)).to be false
      end
    end
  end

  describe "Reflections" do
    let(w) { default_world }
    let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 1.0)) }
    let(shape) do
      s = w.objects[1]
      s.material.ambient = 1.0
      s
    end
    let(i) { intersection(1.0, shape) }
    let(comps) { i.prepare_computations(r) }

    describe "for a nonreflective material" do
      it "is black" do
        expect(w.reflected_color(comps)).to eq black
      end
    end

    describe "for mutually reflective surfaces" do
      let(light) { point_light(point(0.0, 0.0, 0.0), color(1.0, 1.0, 1.0)) }
      let(w) { world() }
      before_each do
        w.light = light
        lower = plane()
        lower.material.reflective = 1.0
        lower.transform = translation(0.0, -1.0, 0.0)
        w.objects << lower
        upper = plane()
        upper.material.reflective = 1.0
        upper.transform = translation(0.0, 1.0, 0.0)
        w.objects << upper
      end
      let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 1.0, 0.0)) }

      it "does not reflect in infinite loop" do
        c = w.color_at(r)
      end
    end

    describe "recursive depth" do
      let(w) { default_world }
      let(shape) do
        s = plane()
        s.material.reflective = 0.5
        s.transform = translation(0.0, -1.0, 0.0)
        s
      end
      let(r) { ray(point(0.0, 0.0, -3.0), vector(0.0, -Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0)) }
      let(i) { intersection(Math.sqrt(2.0), shape) }
      let(comps) { i.prepare_computations(r) }

      it "does not reflect when reached" do
        expect(w.reflected_color(comps, 0)).to eq black
      end
    end


    describe "for a reflective material" do
      let(shape) do
        s = plane()
        s.material.reflective = 0.5
        s.transform = translation(0.0, -1.0, 0.0)
        w.objects << s
        s
      end
      let(r) { ray(point(0.0, 0.0, -3.0), vector(0.0, -Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0)) }
      let(i) { intersection(Math.sqrt(2.0), shape) }
      let(comps) { i.prepare_computations(r) }
      
      it "includes the reflective color" do
        c = color(0.190347, 0.237934, 0.142760)
        expect(w.reflected_color(comps).approximate?(c)).to be true
      end

      describe "shade_hit" do
        it "caclulates the color" do
         c = color(0.87677, 0.92436, 0.82918)
         expect(w.shade_hit(comps).approximate?(c)).to be true
        end
      end
    end
  end

  describe "Refraction" do
    let(w) { default_world }
    let(shape) { w.objects.first }
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(xs) { w.intersect(r) }
    let(comps) { xs[0].prepare_computations(r, xs) }


    describe "with opaque surface" do
      it "is black with opaque surface" do
        c = w.refracted_color(comps, 5)
        expect(c).to eq black
      end
    end

    describe "when max recursion reached" do
      it "is black" do
        shape.material.transparency = 1.0
        c = w.refracted_color(comps, 0)
        expect(c).to eq black
      end
    end

    describe "under total internal reflection" do
      let(r) { ray(point(0.0, 0.0, Math.sqrt(2.0)/2.0), vector(0.0, 1.0, 0.0)) }
      let(comps) { xs[1].prepare_computations(r, xs) }

      it "is black" do
        shape.material.transparency = 1.0
        shape.material.refractive_index = 1.5
        c = w.refracted_color(comps, 5)
        expect(c).to eq black
      end
    end

    describe "with transparent and reflective material" do
      let(r) { ray(point(0.0, 0.0, -3.0), vector(0.0, -Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0)) }
      let(floor) do
        f = plane()
        f.transform = translation(0.0, -1.0, 0.0)
        f.material.reflective = 0.5
        f.material.transparency = 0.5
        f.material.refractive_index = 1.5
        f
      end
      let(ball) do
        b = sphere()
        b.material.color = red
        b.material.ambient = 0.5
        b.transform = translation(0.0, -3.5, -0.5)
        b
      end
      let(w) do
        w = default_world
        w.objects << floor
        w.objects << ball
        w
      end
      let(xs) { w.intersect(r) }
      let(i) { xs[0] }
      let(comps) { i.prepare_computations(r, xs) }

      it "calculates reflection into color" do
        c = w.shade_hit(comps, 5)
        expect(c.approximate?(color(0.93391, 0.69643, 0.69243))).to be true
      end
    end

    describe "with transparent surface" do
      let(w) do
        w = default_world
        a = w.objects[0]
        a.material.ambient = 1.0
        a.material.pattern = test_pattern()
        b = w.objects[1]
        b.material.transparency = 1.0
        b.material.refractive_index = 1.5
        w
      end
      let(r) { ray(point(0.0, 0.0, 0.1), vector(0.0, 1.0, 0.0)) }
      let(xs) { w.intersect(r) }
      let(comps) { xs[2].prepare_computations(r, xs) }

      it "has a refracted color" do
        c = w.refracted_color(comps, 5)
        expect(c.approximate?(color(0.0, 0.99888, 0.04725))).to be true
      end

      describe "shade_hit" do
        let(floor) do
          floor = plane()
          floor.transform = translation(0.0, -1.0, 0.0)
          floor.material.transparency = 0.5
          floor.material.refractive_index = 1.5
          floor
        end
        let(w) do
          w = default_world
          w.objects << floor

          ball = sphere()
          ball.material.color = red
          ball.material.ambient = 0.5
          ball.transform = translation(0.0, -3.5, -0.5)
          w.objects << ball
          w
        end
        let(r) { ray(point(0.0, 0.0, -3.0), vector(0.0, -Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0)) }
        let(i) { intersection(Math.sqrt(2.0), floor) }
        let(comps) { i.prepare_computations(r) }

        it "uses refracted ray" do
          c = w.shade_hit(comps, 5)
          expect(c.approximate?(color(0.93642, 0.68642, 0.68642))).to be true
        end
      end
    end
  end
end

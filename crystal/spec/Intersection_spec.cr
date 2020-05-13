require "./spec_helper"

Spectator.describe Intersection do
  describe "Intersection encapsulation" do
    let(s) { sphere() }
    let(i) { intersection(3.5, s) }
    
    it "includes time(t) and object hit" do
      expect(i.t).to eq 3.5
      expect(i.object).to eq s
    end

    describe "intersection with uv" do
      let(s) { triangle(point(0.0, 1.0, 0.0), point(-1.0, 0.0, 0.0), point(1.0, 0.0, 0.0)) }
      let(i) { intersection_with_uv(3.5, s, 0.2, 0.4) }

      it "can encapsulate 'u' and 'v'" do
        expect(i.u).to eq 0.2
	expect(i.v).to eq 0.4
      end
    end

  end

  describe "Intersections include agregates" do
    let(s) { sphere() }
    let(i1) { intersection(1.0, s) }
    let(i2) { intersection(2.0, s) }

    it "includes a set" do
      xs = intersections(i1, i2)
      expect(xs.size).to eq 2

      expect(xs[0].t).to eq 1.0
      expect(xs[1].t).to eq 2.0
    end
  end

  describe "Hits" do
    describe "when all intersections are positive" do
      let(s) { sphere() }
      let(i1) { intersection(1.0, s) }
      let(i2) { intersection(2.0, s) }
      let(xs) { intersections(i2, i1) }

      it "is the smallest time" do
        expect(xs.hit).to eq (i1)
      end
    end

    describe "when some intersections are negative" do
      let(s) { sphere() }
      let(i1) { intersection(-1.0, s) }
      let(i2) { intersection(1.0, s) }
      let(xs) { intersections(i2, i1) }

      it "is the smallest non negative time" do
        expect(xs.hit).to eq (i2)
      end
    end

    describe "when all intersections are negative" do
      let(s) { sphere() }
      let(i1) { intersection(-2.0, s) }
      let(i2) { intersection(-1.0, s) }
      let(xs) { intersections(i2, i1) }

      it "is null" do
        expect(xs.hit.null?).to eq true
      end
    end

    describe "when in random order" do
      let(s) { sphere() }
      let(i1) { intersection( 5.0, s) }
      let(i2) { intersection( 7.0, s) }
      let(i3) { intersection(-3.0, s) }
      let(i4) { intersection( 2.0, s) }

      let(xs) { intersections(i1, i2, i3, i4) }

      it "is always the lowest non-negative intersection" do
        expect(xs.hit).to eq i4
      end
    end
  end

  describe "preparing computations" do
    let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
    let(s) { sphere() }
    let(i) { intersection(4.0, s) }
    let(comps) { i.prepare_computations(r) }

    it "has time of intersection" do
      expect(comps.t).to eq i.t
    end

    it "has object of intersection" do
      expect(comps.object).to eq i.object
    end

    it "has point relative to position" do
      expect(comps.point).to eq point(0.0, 0.0, -1.0)
    end

    it "has eyev relative to direction of ray" do
      expect(comps.eyev).to eq vector(0.0, 0.0, -1.0)
    end

    it "has normalv relative to normal of object + point" do
      expect(comps.normalv).to eq vector(0.0, 0.0, -1.0)
    end

    describe "reflection vector" do
      let(s) { plane() }
      let(r) { ray(point(0.0, 1.0, -1.0), vector(0.0, -Math.sqrt(2)/2.0, Math.sqrt(2)/2.0)) }
      let(i) { intersection(Math.sqrt(2.0), s) }

      it "is included" do
        comps = i.prepare_computations(r)
        expect(comps.reflectv.approximate?(vector(0.0, Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0))).to be true
      end
    end

    describe "when occuring on the outside" do
      it "is not inside" do
        expect(comps.inside?).to eq false
      end
    end

    describe "when occuring on the inside" do
      let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 0.0, 1.0)) }

      it "is inside" do
        expect(comps.inside?).to eq true
      end

      it "has inverted normal" do
        expect(comps.normalv).to eq vector(0.0, 0.0, -1.0)
      end
    end

    describe "for refraction and transparency" do
      let(a) do
        s = glass_sphere()
        s.transform = scaling(2.0, 2.0, 2.0)
        s.material.refractive_index = 1.5
        s
      end
      let(b) do
        s = glass_sphere()
        s.transform = translation(0.0, 0.0, -0.25)
        s.material.refractive_index = 2.0
        s
      end
      let(c) do
        s = glass_sphere()
        s.transform = translation(0.0, 0.0, 0.25)
        s.material.refractive_index = 2.5
        s
      end
      let(r) { ray(point(0.0, 0.0, -4.0), vector(0.0, 0.0, 1.0)) }
      let(xs) do
        w = world()
        w.objects << a
        w.objects << b
        w.objects << c
        w.intersect(r)
      end
      let(examples) do
        [
          {0, 1.0, 1.5},
          {1, 1.5, 2.0},
          {2, 2.0, 2.5},
          {3, 2.5, 2.5},
          {4, 2.5, 1.5},
          {5, 1.5, 1.0}
        ]
      end

      it "calculates expected n1, n2 values for each intersection" do
        examples.each do |example|
          index, n1, n2 = example
          i = xs[index]
          comps = i.prepare_computations(r, xs)
          expect(comps.n1).to eq n1
          expect(comps.n2).to eq n2
        end
      end
    end

    describe "the under_point" do
      let(r) { ray(point(0.0, 0.0, -5.0), vector(0.0, 0.0, 1.0)) }
      let(shape) do
        s = glass_sphere()
        s.transform = translation(0.0, 0.0, 1.0)
        s
      end
      let(i) { intersection(5.0, shape) }

      it "is just under surface" do
        comps = i.prepare_computations(r)
        expect(comps.under_point.z).to be_gt EPSILON/2.0
        expect(comps.point.z).to be_lt comps.under_point.z
      end
    end
  end

  describe "The Schlick approximation" do
    let(shape) { glass_sphere }
    let(w) do
      w = world
      w.objects << shape
      w
    end
    let(xs) { w.intersect(r) }
    let(i) { xs[1] }
    let(comps) { i.prepare_computations(r, xs) }
    let(reflectance) { comps.schlick() }

    describe "under total reflection" do
      let(r) { ray(point(0.0, 0.0, Math.sqrt(2.0)/2.0), vector(0.0, 1.0, 0.0)) }

      it "reflects totally" do
        expect(reflectance).to eq 1.0
      end
    end

    describe "with perpendicular viewing angle" do
      let(r) { ray(point(0.0, 0.0, 0.0), vector(0.0, 1.0, 0.0)) }

      it "reflects bearly" do
        expect(reflectance).to be_close(0.04, EPSILON)
      end
    end

    describe "when small angle and n2 > n1" do
      let(i) { xs[0] }
      let(r) { ray(point(0.0, 0.99, -2.0), vector(0.0, 0.0, 1.0)) }

      it "reflects partially" do
        expect(reflectance).to be_close(0.48873, EPSILON)
      end
    end

  end
end

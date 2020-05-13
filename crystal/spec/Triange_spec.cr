require "./spec_helper"

Spectator.describe Triangle do
  describe "Construction" do
    let(p1) { point( 0.0, 1.0, 0.0) }
    let(p2) { point(-1.0, 0.0, 0.0) }
    let(p3) { point( 1.0, 0.0, 0.0) }
    let(t) { triangle(p1, p2, p3) }

    it "is made from three points" do
      expect(t.p1).to eq p1
      expect(t.p2).to eq p2
      expect(t.p3).to eq p3
    end

    it "has two edges" do
      expect(t.e1).to eq vector(-1.0,-1.0, 0.0)
      expect(t.e2).to eq vector( 1.0,-1.0, 0.0)
    end

    it "has a normal" do
      expect(t.normal).to eq vector( 0.0, 0.0,-1.0)
    end
  end

  describe "Bounds" do
    let(t) { triangle(point(-1.3, 1.0, 13.5), point(-8.0, -3.4, -4.0), point(1.0, 3.0, 2.4)) }

    it "is the extreme of points" do
      bounds = t.bounds
      expect(bounds.min).to eq point(-8.0, -3.4, -4.0)
      expect(bounds.max).to eq point( 1.0,  3.0, 13.5)
    end
  end

  describe "Finding the normal" do
    let(t) { triangle(point(0.0, 1.0, 0.0), point(-1.0, 0.0, 0.0), point(1.0, 0.0, 0.0)) }
    let(n1) { t.normal_at(point( 0.0, 0.5 , 0.0)) }
    let(n2) { t.normal_at(point(-0.5, 0.75, 0.0)) }
    let(n3) { t.normal_at(point( 0.5, 0.25, 0.0)) }

    it "is always the pre-computed normal" do
      expect(n1).to eq t.normal
      expect(n2).to eq t.normal
      expect(n3).to eq t.normal
    end
  end

  describe "Intersecting" do
    let(t) { triangle(point(0.0,1.0,0.0), point(-1.0,0.0,0.0), point(1.0,0.0,0.0)) }
    let(xs) { t.intersect(r) }

    describe "a ray parallel to the triangle" do
      let(r) { ray(point(0.0,-1.0,-2.0), vector(0.0,1.0,0.0)) }

      it "does not intersect" do
        expect(xs.empty?).to be true
      end
    end

    describe "a ray missing p1-p3 edge" do
      let(r) { ray(point(1.0, 1.0,-2.0), vector(0.0,0.0,1.0)) }

      it "does not intersect" do
        expect(xs.empty?).to be true
      end
    end

    describe "a ray missing p1-p2 edge" do
      let(r) { ray(point(-1.0, 1.0,-2.0), vector(0.0,0.0,1.0)) }

      it "does not intersect" do
        expect(xs.empty?).to be true
      end
    end

    describe "a ray missing p2-p3 edge" do
      let(r) { ray(point( 0.0,-1.0,-2.0), vector(0.0,0.0,1.0)) }

      it "does not intersect" do
        expect(xs.empty?).to be true
      end
    end

    describe "a ray striking the triangle" do
      let(r) { ray(point( 0.0, 0.5,-2.0), vector(0.0,0.0,1.0)) }

      it "does not intersect" do
        expect(xs.size).to eq 1
        expect(xs[0].t).to eq 2.0
      end
    end
  end

  describe SmoothTriangle do
    let(p1) { point( 0.0, 1.0, 0.0) }
    let(p2) { point(-1.0, 0.0, 0.0) }
    let(p3) { point( 1.0, 0.0, 0.0) }
    let(n1) { vector( 0.0, 1.0, 0.0) }
    let(n2) { vector(-1.0, 0.0, 0.0) }
    let(n3) { vector( 1.0, 0.0, 0.0) }

    let(tri) { smooth_triangle(p1, p2, p3, n1, n2, n3) }

    it "has additional properties for normals" do
      expect(tri.p1).to eq p1
      expect(tri.p2).to eq p2
      expect(tri.p3).to eq p3
      expect(tri.n1).to eq n1
      expect(tri.n2).to eq n2
      expect(tri.n3).to eq n3
    end

    describe "Intersections" do
      let(r) { ray(point(-0.2, 0.3,-2.0), vector(0.0, 0.0, 1.0)) }
      let(xs) { tri.intersect(r) }

      it "stores the u/v values" do
        expect(xs[0].u).to be_close 0.45, Float64::EPSILON
	expect(xs[0].v).to be_close 0.25, Float64::EPSILON
      end

      describe "Interpolation of Normals" do
        let(i) { intersection_with_uv(1.0, tri, 0.45, 0.25) }
	let(n) { tri.normal_at(point(0.0, 0.0, 0.0), i) }

	it "uses uv value to interpolate normal" do
	  expect(n).to be_approximate vector(-0.5547, 0.83205, 0.0)
	end
      end

      describe "Preparing normals for smooth triangles" do
        let(i) { intersection_with_uv(1.0, tri, 0.45, 0.25) }
	let(r) { ray(point(-0.2, 0.3,-2.0), vector(0.0, 0.0, 1.0)) }

	let(comps) { i.prepare_computations(r) }

	it "includes hit for normal calculations" do
	  expect(comps.normalv).to be_approximate vector(-0.5547, 0.83205, 0.0)
	end
      end
    end


  end
end

require "./spec_helper"

Spectator.describe Cube do
  describe "a ray intersecting a cube" do
    let(c) { cube() }
    let(examples) { [
      {"+x", point( 5.0, 0.5, 0.0), vector(-1.0, 0.0, 0.0), 4.0, 6.0 },
      {"-x", point(-5.0, 0.5, 0.0), vector( 1.0, 0.0, 0.0), 4.0, 6.0 },
      {"+y", point( 0.5, 5.0, 0.0), vector( 0.0,-1.0, 0.0), 4.0, 6.0 },
      {"-y", point( 0.5,-5.0, 0.0), vector( 0.0, 1.0, 0.0), 4.0, 6.0 },
      {"+z", point( 0.5, 0.0, 5.0), vector( 0.0, 0.0,-1.0), 4.0, 6.0 },
      {"-z", point( 0.5, 0.0,-5.0), vector( 0.0, 0.0, 1.0), 4.0, 6.0 },
      {"inside", point(0.0, 0.5, 0.0), vector(0.0, 0.0, 1.0), -1.0, 1.0 },
    ] }

    it "intesects on all 6 sides" do
      examples.each do |example|
        name, origin, direction, t1, t2 = example
	r = ray(origin, direction)
	xs = c.intersect(r)
	expect(xs.size).to eq 2
	expect(xs[0].t).to eq t1
	expect(xs[1].t).to eq t2
      end
    end
  end

  describe "a ray missing a cube" do
    let(c) { cube() }
    let(examples) { [
      {point(-2.0, 0.0, 0.0), vector( 0.2673, 0.5345, 0.8018)},
      {point( 0.0,-2.0, 0.0), vector( 0.8018, 0.2673, 0.5345)},
      {point( 0.0, 0.0,-2.0), vector( 0.5345, 0.8018, 0.2673)},
      {point( 2.0, 0.0, 2.0), vector( 0.0, 0.0,-1.0)},
      {point( 0.0, 2.0, 2.0), vector( 0.0,-1.0, 0.0)},
      {point( 2.0, 2.0, 0.0), vector(-1.0, 0.0, 0.0)}
    ] }

    it "intesects on all 6 sides" do
      examples.each do |example|
        origin, direction = example
	r = ray(origin, direction)
	xs = c.intersect(r)
	expect(xs.size).to eq 0
      end
    end
  end

  describe "the normal on the surface of a cube" do
    let(c) { cube() }
    let(examples) { [
      {point( 1.0, 0.5,-0.8), vector( 1.0, 0.0, 0.0)},
      {point(-1.0,-0.2, 0.9), vector(-1.0, 0.0, 0.0)},
      {point(-0.4, 1.0,-0.1), vector( 0.0, 1.0, 0.0)},
      {point( 0.3,-1.0,-0.7), vector( 0.0,-1.0, 0.0)},
      {point(-0.6, 0.3, 1.0), vector( 0.0, 0.0, 1.0)},
      {point( 0.4, 0.4,-1.0), vector( 0.0, 0.0,-1.0)},
      {point( 1.0, 1.0, 1.0), vector( 1.0, 0.0, 0.0)},
      {point(-1.0,-1.0,-1.0), vector(-1.0, 0.0, 0.0)}
    ] }

    it "is perpendicular to each face" do
      examples.each do |example|
        point, normal = example
	expect(c.normal_at(point)).to eq normal
      end
    end
  end
end

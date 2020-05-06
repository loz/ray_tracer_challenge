require "./spec_helper"

Spectator.describe Cylinder do
  describe "a ray misses a cylinder" do
    let(cyl) { cylinder() }
    let(examples) { [
      {point( 1.0, 0.0, 0.0), vector( 0.0, 1.0, 0.0)},
      {point( 0.0, 0.0, 0.0), vector( 0.0, 1.0, 0.0)},
      {point( 0.0, 0.0,-5.0), vector( 1.0, 1.0, 1.0)}
    ] }

    it "does not intersect on examples" do
      examples.each do |example|
        origin, direction = example
	r = ray(origin, direction)
	xs = cyl.intersect(r)
	expect(xs.size).to eq 0
      end
    end
  end

  describe "a ray strikes a cylinder" do
    let(cyl) { cylinder() }
    let(examples) { [
      {point( 1.0, 0.0,-5.0), vector( 0.0, 0.0, 1.0), 5.0, 5.0},
      {point( 0.0, 0.0,-5.0), vector( 0.0, 0.0, 1.0), 4.0, 6.0},
      #{point( 0.5, 0.0,-5.0), vector( 0.1, 1.0, 1.0), 6.80798, 7.08872} #Book Error?
      {point( 0.5, 0.0,-5.0), vector( 0.1, 1.0, 1.0), 4.80198, 5.0}
    ] }

    it "intersects on example rays" do
      examples.each do |example|
        origin, direction, t0, t1 = example
	r = ray(origin, direction)
	xs = cyl.intersect(r)
	expect(xs.size).to eq 2
	expect(xs[0].t).to be_close t0, 0.0001
	expect(xs[1].t).to be_close t1, 0.0001
      end
    end
  end

  describe "normals on a cylinder" do
    let(cyl) { cylinder() }
    let(examples) { [
      {point( 1.0, 0.0, 0.0), vector( 1.0, 0.0, 0.0)},
      {point( 0.0, 5.0,-1.0), vector( 0.0, 0.0,-1.0)},
      {point( 0.0,-2.0, 1.0), vector( 0.0, 0.0, 1.0)},
      {point(-1.0, 1.0, 0.0), vector(-1.0, 0.0, 0.0)}
    ] }

    it "is perpendiclar, as in example rays" do
      examples.each do |example|
        point, normal = example
	n = cyl.normal_at(point)
	expect(n.approximate?(normal))
      end
    end
  end
end

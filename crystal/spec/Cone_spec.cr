require "./spec_helper"

Spectator.describe Cone do
  describe "a ray which intersects" do
    let(shape) { cone() }
    let(examples) { [
      {point( 0.0, 0.0,-5.0), vector( 0.0, 0.0, 1.0), 5.0,     5.0},
      {point( 0.0, 0.0,-5.0), vector( 1.0, 1.0, 1.0), 8.66025, 8.66025},
      {point( 1.0, 1.0,-5.0), vector(-0.5,-1.0, 1.0), 4.55006,49.44994}
    ] }

    it "intersects on example rays" do
      examples.each do |example|
        origin, direction, t0, t1 = example
	r = ray(origin, direction.normalize)
	xs = shape.intersect(r)
	expect(xs.size).to eq 2
	expect(xs[0].t).to be_close t0, 0.00001
	expect(xs[1].t).to be_close t1, 0.00001
      end
    end
  end

  describe "intersecting with a ray parallel to one half" do
    let(shape) { cone }
    let(r) { ray(point(0.0, 0.0, -1.0), vector(0.0, 1.0, 1.0).normalize) }
    let(xs) { shape.intersect(r) }

    it "intersects once" do
      expect(xs.size).to eq 1
      expect(xs[0].t).to be_close 0.35355, 0.00001
    end
  end

  describe "intersecting end-caps" do
    let(shape) do
      c = cone()
      c.minimum = -0.5
      c.maximum =  0.5
      c.closed = true
      c
    end

    let(examples) { [
      {point( 0.0, 0.0,-5.0 ), vector( 0.0, 1.0, 0.0), 0},
      {point( 0.0, 0.0,-0.25), vector( 0.0, 1.0, 1.0), 2},
      {point( 0.0, 0.0,-0.25), vector( 0.0, 1.0, 0.0), 4}
    ] }

    it "intersects on example rays" do
      examples.each do |example|
        origin, direction, tcount = example
	r = ray(origin, direction.normalize)
	xs = shape.intersect(r)
	expect(xs.size).to eq tcount
      end
    end
  end

  describe "Computing normal of a cone" do
    let(shape) { cone() }
    let(examples) { [
      {point( 0.0, 0.0, 0.0), vector( 0.0, 0.0, 0.0)},
      {point( 1.0, 1.0, 1.0), vector( 1.0, -Math.sqrt(2.0), 1.0)},
      {point(-1.0,-1.0, 0.0), vector(-1.0, 1.0, 0.0)}
    ] }

    it "is perpendiclar, as in example rays" do
      examples.each do |example|
        point, normal = example
	n = shape.normal_at(point)
	expect(n.approximate?(normal))
      end
    end
  end
end

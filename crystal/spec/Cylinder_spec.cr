require "./spec_helper"

Spectator.describe Cylinder do
  let(cyl) { cylinder() }

  describe "a ray misses a cylinder" do
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

  describe "Bounds" do
    it "is infinte in y" do
      bounds = cyl.bounds
      expect(bounds.min).to eq point(-1.0, -Float64::INFINITY,-1.0)
      expect(bounds.max).to eq point( 1.0,  Float64::INFINITY, 1.0)
    end

    describe "When constrained" do
      before_each do
        cyl.minimum = -3.0
        cyl.maximum =  4.5
      end

      it "is bounds within constraints" do
        bounds = cyl.bounds
        expect(bounds.min).to eq point(-1.0, -3.0,-1.0)
        expect(bounds.max).to eq point( 1.0,  4.5, 1.0)
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

  describe "Constraints" do
    let(cyl) { cylinder() }
    it "has inifinte size by default" do
      expect(cyl.minimum).to eq -Float64::INFINITY
      expect(cyl.maximum).to eq Float64::INFINITY
    end

    describe "intersecting with" do
      let(cyl) do
        c = cylinder
        c.minimum = 1.0
        c.maximum = 2.0
        c
      end

      let(examples) { [
        {point( 0.0, 1.5, 0.0), vector( 0.1, 1.0, 0.0), 0},
        {point( 0.0, 3.0,-5.0), vector( 0.0, 0.0, 1.0), 0},
        {point( 0.0, 0.0,-5.0), vector( 0.0, 0.0, 1.0), 0},
        {point( 0.0, 2.0,-5.0), vector( 0.0, 0.0, 1.0), 0},
        {point( 0.0, 1.0,-5.0), vector( 0.0, 0.0, 1.0), 0},
        {point( 0.0, 1.5,-2.0), vector( 0.0, 0.0, 1.0), 2}
      ] }

      it "only intersects within the constraints" do
        examples.each do |example|
          point, direction, count = example
          r = ray(point, direction)
          xs = cyl.intersect(r)
          expect(xs.size).to eq count
        end
      end
    end
  end

  describe "Capping" do
    let(cyl) { cylinder }
    it "is open by default" do
      expect(cyl.closed).to be false
    end

    describe "intersecting with closed cylinder" do
      let(cyl) do
        c = cylinder
        c.minimum = 1.0
        c.maximum = 2.0
	c.closed = true
        c
      end

      let(examples) { [
        {point( 0.0, 3.0, 0.0), vector( 0.0,-1.0, 0.0), 2},
        {point( 0.0, 3.0,-2.0), vector( 0.0,-1.0, 2.0), 2}, 
        {point( 0.0, 4.0,-2.0), vector( 0.0,-1.0, 1.0), 2}, #Corner
        {point( 0.0, 0.0,-2.0), vector( 0.0, 1.0, 2.0), 2},
        {point( 0.0,-1.0,-2.0), vector( 0.0, 1.0, 1.0), 2}, #Corner
      ] }

      it "intersects with cap, including on corners" do
        examples.each do |example|
          point, direction, count = example
          r = ray(point, direction)
          xs = cyl.intersect(r)
          expect(xs.size).to eq count
        end
      end
    end

    describe "normals on a cylinder cap" do
      let(cyl) do
      	c = cylinder()
	c.minimum = 1.0
	c.maximum = 2.0
	c.closed = true
	c
      end
      let(examples) { [
        {point( 0.0, 1.0, 0.0), vector( 0.0,-1.0, 0.0)},
        {point( 0.5, 1.0, 0.0), vector( 0.0,-1.0, 0.0)},
        {point( 0.0, 1.0, 0.5), vector( 0.0,-1.0, 0.0)},
        {point( 0.0, 2.0, 0.0), vector( 0.0, 1.0, 0.0)},
        {point( 0.5, 2.0, 0.0), vector( 0.0, 1.0, 0.0)},
        {point( 0.0, 2.0, 0.5), vector( 0.0, 1.0, 0.0)}
      ] }

      it "is vertical +/- for top and bottom caps" do
        examples.each do |example|
          point, normal = example
          n = cyl.normal_at(point)
          expect(n).to eq normal
        end
      end
    end

  end
end

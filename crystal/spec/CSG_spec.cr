require "./spec_helper"

Spectator.describe CSG do
  let(s1) { sphere() }
  let(s2) { cube() }

  describe "creation" do
    let(c) { csg(:union, s1, s2) }

    it "creates the object with components and operation" do
      expect(c.left).to eq s1
      expect(c.right).to eq s2
      expect(c.operation).to eq :union

      expect(s1.parent).to eq c
      expect(s2.parent).to eq c
    end
  end

  describe "Union Rule Evaluation" do
      #Op      lhit   inl    inr    result
    let(examples) {[
      {:union, true,  true,  true,  false},
      {:union, true,  true,  false, true},
      {:union, true,  false, true,  false},
      {:union, true,  false, false, true},
      {:union, false, true,  true,  false},
      {:union, false, true,  false, false},
      {:union, false, false, true,  true},
      {:union, false, false, false, true}
    ]}

    it "calculates according to union boolean logic" do
      examples.each do |example|
        op, lhit, inl, inr, result = example
	expect(CSG.intersection_allowed(op, lhit, inl, inr)).to be result
      end
    end
  end

  describe "Intersection Rule Evaluation" do
      #Op      lhit   inl    inr    result
    let(examples) {[
      {:intersection, true,  true,  true,  true},
      {:intersection, true,  true,  false, false},
      {:intersection, true,  false, true,  true},
      {:intersection, true,  false, false, false},
      {:intersection, false, true,  true,  true},
      {:intersection, false, true,  false, true},
      {:intersection, false, false, true,  false},
      {:intersection, false, false, false, false}
    ]}

    it "calculates according to intersect boolean logic" do
      examples.each do |example|
        op, lhit, inl, inr, result = example
	expect(CSG.intersection_allowed(op, lhit, inl, inr)).to be result
      end
    end
  end


  describe "Difference Rule Evaluation" do
      #Op      lhit   inl    inr    result
    let(examples) {[
      {:difference, true,  true,  true,  false},
      {:difference, true,  true,  false, true},
      {:difference, true,  false, true,  false},
      {:difference, true,  false, false, true},
      {:difference, false, true,  true,  true},
      {:difference, false, true,  false, true},
      {:difference, false, false, true,  false},
      {:difference, false, false, false, false}
    ]}

    it "calculates according to intersect boolean logic" do
      examples.each do |example|
        op, lhit, inl, inr, result = example
	expect(CSG.intersection_allowed(op, lhit, inl, inr)).to be result
      end
    end
  end

  describe "Filtering intersections" do
    let(xs) do
      intersections = Intersections.new
      intersections << intersection(1.0, s1)
      intersections << intersection(2.0, s2)
      intersections << intersection(3.0, s1)
      intersections << intersection(4.0, s2)
      intersections
    end

    let(examples) { [
       {:union, 0, 3},
       {:intersection, 1, 2},
       {:difference, 0, 1}
    ]}

    it "filters according to the boolean" do
      examples.each do |example|
        op, x0, x1 = example
	c = csg(op, s1, s2)
        result = c.filter_intersections(xs)
	expect(result[0]).to eq xs[x0]
	expect(result[1]).to eq xs[x1]
      end
    end
    
    describe "with groups and csg combination" do
      let(g1) do
        g = Group.new
        g << s1
        g
      end
      
      let(g2) do
        s3 = sphere()
        g = CSG.new(:union, s2, s3)
        g
      end

      it "filters according to the boolean of nested children" do
        examples.each do |example|
          op, x0, x1 = example
          c = csg(op, g1, g2)
          result = c.filter_intersections(xs)
          expect(result[0]).to eq xs[x0]
          expect(result[1]).to eq xs[x1]
        end
      end
    end
  end

  describe "Intersective" do
    let(c) { csg(:union, sphere(), cube()) }
    let(r) { ray(point(0.0, 2.0,-5.0), vector(0.0, 0.0, 1.0)) }
    let(xs) { c.intersect(r) }

    describe "When a ray misses" do
      it "has no intersects" do
        expect(xs).to be_empty
      end
    end

    describe "when it hits an object" do
      let(s1) { sphere() }
      let(s2) do
        s = sphere()
	s.transform = translation(0.0, 0.0, 0.5)
	s
      end
      let(c) { csg(:union, s1, s2) }
      let(r) { ray(point(0.0, 0.0,-5.0), vector(0.0, 0.0, 1.0)) }

      it "intersects with objects filtered according to the boolean logic" do
        expect(xs[0].t).to eq 4.0
	expect(xs[0].object).to eq s1
	expect(xs[1].t).to eq 6.5
	expect(xs[1].object).to eq s2
      end
    end
  end
end

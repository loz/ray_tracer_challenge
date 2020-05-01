Spectator.describe Patterns do

  describe "Stripes" do
    let(pattern) { stripe_pattern(white, black) }

    it "has properties" do
      expect(pattern.a.as(Canvas::Color)).to eq white
      expect(pattern.b.as(Canvas::Color)).to eq black
    end

    it "is constant in y" do
      expect(pattern.at(point(0.0, 0.0, 0.0))).to eq white
      expect(pattern.at(point(0.0, 1.0, 0.0))).to eq white
      expect(pattern.at(point(0.0, 2.0, 0.0))).to eq white
    end

    it "is constant in z" do
      expect(pattern.at(point(0.0, 0.0, 0.0))).to eq white
      expect(pattern.at(point(0.0, 0.0, 1.0))).to eq white
      expect(pattern.at(point(0.0, 0.0, 2.0))).to eq white
    end

    it "is alternating in x" do
      expect(pattern.at(point(0.0, 0.0, 0.0))).to eq white
      expect(pattern.at(point(0.9, 0.0, 0.0))).to eq white
      expect(pattern.at(point(1.0, 0.0, 0.0))).to eq black
      expect(pattern.at(point(-0.1, 0.0, 0.0))).to eq black
      expect(pattern.at(point(-0.1, 0.0, 0.0))).to eq black
      expect(pattern.at(point(-1.0, 0.0, 0.0))).to eq black
      expect(pattern.at(point(-1.1, 0.0, 0.0))).to eq white
    end

    describe "with an object transformation" do
      let(object) { sphere }

      it "has transformed patter" do
        object.transform = scaling(2.0, 2.0, 2.0)
	c = pattern.at_object(object, point(1.5, 0.0, 0.0))

	expect(c).to eq white
      end
    end

    describe "with a pattern transformation" do
      let(object) { sphere }

      it "has transformed patter" do
        pattern.transform = scaling(2.0, 2.0, 2.0)
	c = pattern.at_object(object, point(1.5, 0.0, 0.0))

	expect(c).to eq white
      end
    end

    describe "with a both object and pattern transformation" do
      let(object) { sphere }

      it "has transformed patter" do
        object.transform = scaling(2.0, 2.0, 2.0)
        pattern.transform = translation(0.5, 0.0, 0.0)
	c = pattern.at_object(object, point(2.5, 0.0, 0.0))

	expect(c).to eq white
      end
    end

  end

  describe "Gradient" do
    let(pattern) { gradient_pattern(white, black) }

    it "has blended colors" do
      expect(pattern.at(point(0.0, 0.0, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(0.25, 0.0, 0.0)).approximate?(color(0.75, 0.75, 0.75))).to be true
      expect(pattern.at(point(0.5, 0.0, 0.0)).approximate?(color(0.5, 0.5, 0.5))).to be true
      expect(pattern.at(point(0.75, 0.0, 0.0)).approximate?(color(0.25, 0.25, 0.25))).to be true
    end
  end

  describe "Ring Pattern" do
    let(pattern) { ring_pattern(white, black) }

    it "extends in x and y" do
      expect(pattern.at(point(0.0, 0.0, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(1.0, 0.0, 0.0)).approximate?(black)).to be true
      expect(pattern.at(point(0.0, 0.0, 1.0)).approximate?(black)).to be true
      expect(pattern.at(point(0.708, 0.0, 0.708)).approximate?(black)).to be true
    end
  end

  describe "Checker Pattern" do
    let(pattern) { checks_pattern(white, black) }

    it "repeats in x" do
      expect(pattern.at(point(0.0, 0.0, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(0.99, 0.0, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(1.01, 0.0, 0.0)).approximate?(black)).to be true
    end

    it "repeats in y" do
      expect(pattern.at(point(0.0, 0.0, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(0.0, 0.99, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(0.0, 1.01, 0.0)).approximate?(black)).to be true
    end

    it "repeats in z" do
      expect(pattern.at(point(0.0, 0.0, 0.0)).approximate?(white)).to be true
      expect(pattern.at(point(0.0, 0.0, 0.99)).approximate?(white)).to be true
      expect(pattern.at(point(0.0, 0.0, 1.01)).approximate?(black)).to be true
    end
  end

  describe "Nesting Pattern" do
    let(stripe1) do
      p = stripe_pattern(white, black)
      p.transform = scaling(0.25, 0.25, 0.25)
      p
    end
    let(stripe2) do
      p = stripe_pattern(white, black)
      p.transform = scaling(0.25, 0.25, 0.25) *
                      rotation_z(Math::PI/2)
      p
    end

    let(nested) { checks_pattern(stripe1, stripe2) }

    it "uses the pattern in place of a color" do
      expect(nested.at(point(0.0, 0.0, 0.0)).approximate?(white)).to be true
      expect(nested.at(point(0.26, 0.0, 0.0)).approximate?(black)).to be true
      expect(nested.at(point(0.51, 0.0, 0.0)).approximate?(white)).to be true

      expect(nested.at(point(1.26, 0.0, 0.0)).approximate?(white)).to be true
      expect(nested.at(point(1.26, 0.26, 0.0)).approximate?(black)).to be true
      expect(nested.at(point(1.26, 0.51, 0.0)).approximate?(white)).to be true
    end
  end
end

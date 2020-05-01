Spectator.describe Patterns do

  describe "Stripes" do
    let(pattern) { stripe_pattern(white, black) }

    it "has properties" do
      expect(pattern.a).to eq white
      expect(pattern.b).to eq black
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


end

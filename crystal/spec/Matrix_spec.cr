require "./spec_helper"

Spectator.describe Matrix do
  describe "constucting 4x4 matrix" do
    let(m) do
      matrix({ { 1.0,  2.0,  3.0,  4.0},
               { 5.5,  6.5,  7.5,  8.5},
               { 9.0, 10.0, 11.0, 12.0},
               {13.4, 14.5, 15.5, 16.5} })
    end

    it "has 4x4 elements accessible" do
      expect(m[0,0]).to eq 1.0
      expect(m[0,3]).to eq 4.0
      expect(m[1,0]).to eq 5.5
      expect(m[3,2]).to eq 15.5
    end
  end

  describe "contstucting a 2x2 matrix" do
    let(m) do
      matrix({ { -3.0,  5.0},
               {  1.0, -2.0} })
    end

    it "has 4x4 elements accessible" do
      expect(m[0,0]).to eq -3.0
      expect(m[0,1]).to eq 5.0
      expect(m[1,0]).to eq 1.0
      expect(m[1,1]).to eq -2.0
    end
  end

  describe "contstucting a 3x3 matrix" do
    let(m) do
      matrix({ { -3.0,  5.0,  0.0 },
               {  1.0, -2.0, -7.0 },
               {  0.0,  1.0,  1.0 } })
    end

    it "has 4x4 elements accessible" do
      expect(m[0,0]).to eq -3.0
      expect(m[1,1]).to eq -2.0
      expect(m[2,2]).to eq 1.0
    end
  end

  describe "equality" do
    let(a) do
      matrix({ { 1.0,  2.0,  3.0,  4.0},
               { 5.5,  6.5,  7.5,  8.5},
               { 9.0, 10.0, 11.0, 12.0},
               {13.4, 14.5, 15.5, 16.5} })
    end
    let(b) do
      matrix({ { 1.0,  2.0,  3.0,  4.0},
               { 5.5,  6.5,  7.5,  8.5},
               { 9.0, 10.0, 11.0, 12.0},
               {13.4, 14.5, 15.5, 16.5} })
    end
    let(c) do
      matrix({ { 1.0,  2.0,  3.0,  4.0},
               { 5.0,  6.0,  7.0,  8.0},
               { 9.0, 10.0, 11.0, 12.0},
               {13.0, 14.0, 15.0, 16.0} })
    end

    it "considers equal values as equal" do
       expect(a).to eq b
    end

    it "does not consider different values equal" do
       expect(a).to_not eq c
    end
  end

  describe "Multiplying 4x4 matrices" do
    let(a) do
      matrix({
        {1.0, 2.0, 3.0, 4.0},
        {5.0, 6.0, 7.0, 8.0},
        {9.0, 8.0, 7.0, 6.0},
        {5.0, 4.0, 3.0, 2.0} }
        )
    end

    let(b) do
      matrix({
        {-2.0, 1.0, 2.0, 3.0},
        { 3.0, 2.0, 1.0,-1.0},
        { 4.0, 3.0, 6.0, 5.0},
        { 1.0, 2.0, 7.0, 8.0} }
        )
    end

    it "can multiply values correctly" do
       expect(a * b).to eq matrix({
        {20.0, 22.0,  50.0,  48.0},
        {44.0, 54.0, 114.0, 108.0},
        {40.0, 58.0, 110.0, 102.0},
        {16.0, 26.0,  46.0,  42.0} })
    end
  end

  describe "Matrix multiplied by tuple" do
    let(a) do
      matrix({
        {1.0, 2.0, 3.0, 4.0},
        {2.0, 4.0, 4.0, 2.0},
        {8.0, 6.0, 4.0, 1.0},
        {0.0, 0.0, 0.0, 1.0} }
        )
    end
    let(b) { tuple(1.0, 2.0, 3.0, 1.0) }

    it "calculates a new tuple" do
      expect(a * b).to eq tuple(18.0, 24.0, 33.0, 1.0)
    end
  end
end

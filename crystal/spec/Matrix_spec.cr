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

  describe "Identity matrix" do
    let(a) do
      matrix({
        {0.0, 1.0, 2.0, 4.0},
        {1.0, 2.0, 4.0, 8.0},
        {2.0, 4.0, 8.0, 16.0},
        {4.0, 8.0, 16.0, 32.0} }
        )
    end

    it "multiplies to self" do
      expect(a * identity_matrix).to eq a
    end
  end

  describe "transpose" do
    let(a) do
      matrix({
        {0.0, 9.0, 3.0, 0.0},
        {9.0, 8.0, 0.0, 8.0},
        {1.0, 8.0, 5.0, 3.0},
        {0.0, 0.0, 5.0, 8.0} }
        )
    end

    it "reflects along diagonal" do
      expect(a.transpose).to eq matrix({
        {0.0, 9.0, 1.0, 0.0},
        {9.0, 8.0, 8.0, 0.0},
        {3.0, 0.0, 5.0, 5.0},
        {0.0, 8.0, 3.0, 8.0}
      })
    end

    it "tansposes identity to self" do
      expect(identity_matrix.transpose).to eq identity_matrix
    end
  end

  describe "Calculating determinant of 2x2" do
    let(a) do
      matrix({
        { 1.0, 5.0},
        {-3.0, 2.0}
      })
    end

    it "is ad - bc" do
      expect(a.determinant).to eq 17
    end
  end

  describe "Calculating determinant of 3x3" do
    let(a) do
      matrix({ 
        { 1.0, 2.0, 6.0},
        {-5.0, 8.0,-4.0},
        { 2.0, 6.0, 4.0}
      })
    end

    it "uses cofactors" do
      expect(a.cofactor(0,0)).to eq 56.0
      expect(a.cofactor(0,1)).to eq 12.0
      expect(a.cofactor(0,2)).to eq -46.0
      expect(a.determinant).to eq -196.0
    end
  end

  describe "Calculating determinant of 4x4" do
    let(a) do
      matrix({ 
        {-2.0,-8.0, 3.0, 5.0},
        {-3.0, 1.0, 7.0, 3.0},
        { 1.0, 2.0,-9.0, 6.0},
        {-6.0, 7.0, 7.0,-9.0}
      })
    end

    it "uses cofactors" do
      expect(a.cofactor(0,0)).to eq 690
      expect(a.cofactor(0,1)).to eq 447
      expect(a.cofactor(0,2)).to eq 210
      expect(a.cofactor(0,3)).to eq 51
      expect(a.determinant).to eq -4071
    end
  end

  describe "Submatrices" do
    describe "3x3" do
      let(a) do
        matrix({
          { 1.0,  5.0,  0.0},
          {-3.0,  2.0,  7.0},
          { 0.0,  6.0, -3.0}
        })
      end

      it "has a 2x2 submatrix, removing stated row and col" do
        expect(a.submatrix(0,2)).to eq matrix({
          {-3.0, 2.0},
          { 0.0, 6.0}
        })
      end
    end

    describe "4x4" do
      let(a) do
        matrix({
          {-6.0, 1.0, 1.0, 6.0},
          {-8.0, 5.0, 8.0, 6.0},
          {-1.0, 0.0, 8.0, 2.0},
          {-7.0, 0.0,-1.0, 1.0}
        })
      end

      it "has a 3x3 submatrix, removing stated row and col" do
        expect(a.submatrix(2,1)).to eq matrix({
          {-6.0, 1.0, 6.0},
          {-8.0, 8.0, 6.0},
          {-7.0,-1.0, 1.0}
        })
      end
    end
  end

  describe "Minors" do
    describe "of 3x3" do
      let(a) do
        matrix({
          {3.0, 5.0, 0.0},
          {2.0,-1.0,-7.0},
          {6.0,-1.0, 5.0}
        })
      end
      let(b) { a.submatrix(1,0) }

      it "has minor of determinant of submatrix" do
        expect(a.minor(1,0)).to eq b.determinant
      end
    end
  end

  describe "Cofactors" do
    describe "of 3x3" do
      let(a) do
        matrix({
          {3.0, 5.0, 0.0},
          {2.0,-1.0,-7.0},
          {6.0,-1.0, 5.0}
        })
      end
      let(b) { a.submatrix(1,0) }

      it "computes cofactors" do
        expect(a.minor(0,0)).to eq -12.0
        expect(a.cofactor(0,0)).to eq -12.0
        expect(a.minor(1,0)).to eq 25.0
        expect(a.cofactor(1,0)).to eq -25.0
      end
    end
  end

  describe "Inverting" do
    describe "a non zero determinant" do
      let(a) do
        matrix({
          {6.0, 4.0, 4.0, 4.0},
          {5.0, 5.0, 7.0, 6.0},
          {4.0,-9.0, 3.0,-7.0},
          {9.0, 1.0, 7.0,-6.0}
        })
      end

      it "is invertable" do
        expect(a.determinant).to eq -2120.0
        expect(a.invertible?).to eq true
      end
    end

    describe "a zero determinant" do
      let(a) do
        matrix({
          {-4.0, 2.0,-2.0,-3.0},
          { 9.0, 6.0, 2.0, 6.0},
          { 0.0,-5.0, 1.0,-5.0},
          { 0.0, 0.0, 0.0, 0.0}
        })
      end

      it "is invertable" do
        expect(a.determinant).to eq 0.0
        expect(a.invertible?).to eq false
      end
    end

    describe "caclulating inverse of 4x4" do
      let(a) do
        matrix({
          {-5.0, 2.0, 6.0,-8.0},
          { 1.0,-5.0, 1.0, 8.0},
          { 7.0, 7.0,-6.0,-7.0},
          { 1.0,-3.0, 7.0, 4.0}
        })
      end
      let(b) { a.inverse }

      it "uses rations of cofactors and determinant" do
        expect(a.determinant).to eq 532.0
        expect(a.cofactor(2,3)).to eq -160.0
        expect(b[3,2]).to eq -160.0/532.0

        expect(a.cofactor(3,2)).to eq 105.0
        expect(b[2,3]).to eq 105.0/532.0

        expect(b.approx(matrix({
          { 0.21805, 0.45113, 0.24060,-0.04511},
          {-0.80827,-1.45677,-0.44361, 0.52068},
          {-0.07895,-0.22368,-0.05263, 0.19737},
          {-0.52256,-0.81391,-0.30075, 0.30639}
        }))).to be true
      end

      it "works for another example" do
        a = matrix({
          { 8.0,-5.0, 9.0, 2.0},
          { 7.0, 5.0, 6.0, 1.0},
          {-6.0, 0.0, 9.0, 6.0},
          {-3.0, 0.0,-9.0,-4.0}
        })

        expect(a.inverse.approx(matrix({
         {-0.15385 ,-0.15385 ,-0.28205 ,-0.53846 },
         {-0.07692 , 0.12308 , 0.02564 , 0.03077 },
         { 0.35897 , 0.35897 , 0.43590 , 0.92308 },
         {-0.69231 ,-0.69231 ,-0.76923 ,-1.92308 }
        }))).to be true
      end

      it "works for yet another example" do
        a = matrix({
          { 9.0, 3.0, 0.0, 9.0},
          {-5.0,-2.0,-6.0,-3.0},
          {-4.0, 9.0, 6.0, 4.0},
          {-7.0, 6.0, 6.0, 2.0}
        })

        expect(a.inverse.approx(matrix({
          {-0.04074 ,-0.07778 , 0.14444 ,-0.22222 },
          {-0.07778 , 0.03333 , 0.36667 ,-0.33333 },
          {-0.02901 ,-0.14630 ,-0.10926 , 0.12963 },
          { 0.17778 , 0.06667 ,-0.26667 , 0.33333 }
        }))).to be true

      end
    end

    describe "Multiplying by inverse" do
      let(a) do
        matrix({
          { 3.0,-9.0, 7.0, 3.0},
          { 3.0,-8.0, 2.0,-9.0},
          {-4.0, 4.0, 4.0, 1.0},
          {-6.0, 5.0,-1.0, 1.0}
        })
      end

      let(b) do
        matrix({
          { 8.0, 2.0, 2.0, 2.0},
          { 3.0,-1.0, 7.0, 0.0},
          { 7.0, 0.0, 5.0, 4.0},
          { 6.0,-2.0, 0.0, 5.0}
        })
      end


      it "a*b * inverse(b) -> a" do
        c = a * b
        expect((c * b.inverse).approx(a)).to eq true
      end
    end
  end
end

require "./spec_helper"

Spectator.describe Canvas do
  describe "Color" do
    let(c) { color(-0.5, 0.4, 1.7) }

    it "is a red, green, blue tuple" do
      expect(c.red).to eq(-0.5)
      expect(c.green).to eq(0.4)
      expect(c.blue).to eq(1.7)
    end
  end

  describe "Creating A Canvas" do
    let(c) { Canvas.new(10, 20) }

    it "has width and height given" do
       expect(c.width).to eq(10)
       expect(c.height).to eq(20)
    end

    it "has every pixel is color(0,0,0)" do
       expect(c.pixel_at(2,3)).to eq(color(0.0,0.0,0.0))
       expect(c.pixel_at(9,19)).to eq(color(0.0,0.0,0.0))
       expect(c.pixel_at(5,16)).to eq(color(0.0,0.0,0.0))
    end
  end

  describe "Writing Pixels" do
    let(c) { Canvas.new(10, 20) }
    let(red) { color(1.0, 0.0, 0.0) }
   
    it "sets the color of the pixel at the location" do
      c.write_pixel(2, 3, red)
      expect(c.pixel_at(2, 3)).to eq(red)
    end
  end

  describe "To PPM" do
    let(c) { Canvas.new(5, 3) }

    it "has header lines of ppm" do
       ppm = c.to_ppm()
       expect(ppm.lines[0,3]).to eq [
	   "P3",
           "5 3",
           "255"
	]
    end

    it "includes pixel data, R:255, G:255, B:255" do
       c.write_pixel(0, 0, color(1.5, 0.0, 0.0))
       c.write_pixel(2, 1, color(0.0, 0.5, 0.0))
       c.write_pixel(4, 2, color(-0.5, 0.0, 1.0))

       expect(c.to_ppm().lines[3,3]).to eq [
          "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
	  "0 0 0 0 0 0 0 127 0 0 0 0 0 0 0",
	  "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
       ]
    end

    it "splits longer lines than 70 chars" do
    	c =  Canvas.new(10, 2)
	pix = color(1.0, 0.8, 0.6)
	10.times do |x|
	  2.times do |y|
	    c.write_pixel(x, y, pix)
	  end
	end

	expect(c.to_ppm().lines[3,4]).to eq [
	  "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
	  "153 255 204 153 255 204 153 255 204 153 255 204 153",
	  "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
	  "153 255 204 153 255 204 153 255 204 153 255 204 153",
	]

    end

    it "ends with a newline" do
      expect(c.to_ppm().lines.last).to eq ""
    end
  end
end

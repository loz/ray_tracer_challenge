class Tuple
	attr_reader :x, :y, :z

  def initialize(x, y, z, w)
		@x = x
		@y = y
		@z = z
		@w = w
  end

	def point?
		@w == 1.0
	end

	def vector?
		@w == 0.0
	end
end

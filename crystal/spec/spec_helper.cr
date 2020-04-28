require "spec"
require "spectator"
require "../src/RayTracer"
require "../src/RTuple"
require "../src/Canvas"

EPSILON = 0.0001

def approximate(val, cmp)
  val > cmp - EPSILON &&
  val < cmp + EPSILON
end

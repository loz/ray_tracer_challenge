require "./src/RayTracer"

print "Identity:"
p identity_matrix

print "inverted:"
p identity_matrix.inverse
#(Same)

a = matrix({
 {1.0, 2.0, 3.0, 4.0},
 {5.0,-6.0, 7.0, 8.0},
 {8.0, 7.0, 6.0, 5.0},
 {4.0, 3.0, 2.0, 3.0}
})

print "Multiply by inverse\n"
p a.invertible?
p a
p a.inverse
p a * a.inverse
p (a * a.inverse).approx(identity_matrix)
#{Approimates to Identity Matrix}



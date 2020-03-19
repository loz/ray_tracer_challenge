Given("{var} <- tuple:{float}, {float}, {float}, {float}") do |var, float, float2, float3, float4|
  @variables ||= {}
  @variables[var] = Tuple.new(float, float2, float3, float4)
end

Then("{var}.{var} = {float}") do |var,string,float|
  @variables ||= {}
  assert_equal(@variables[var].send(string),float)
end

Then("{var} is a point") do |var|
  @variables ||= {}
  assert(@variables[var].point?)
end

Then("{var} is not a point") do |var|
  @variables ||= {}
  assert_false(@variables[var].point?)
end

Then("{var} is a vector") do |var|
  @variables ||= {}
  assert(@variables[var].vector?)
end

Then("{var} is not a vector") do |var|
  @variables ||= {}
  assert_false(@variables[var].vector?)
end

Then("{var} + {var} = tuple:{float}, {float}, {float}, {float}") do |var1, var2, float, float2, float3, float4|
end

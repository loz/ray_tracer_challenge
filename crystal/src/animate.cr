def animated(camera, world, frames = 100, from=0)
  puts "Rendering..."
  frames.times do |f|
    next if f < from
    seq = sprintf("%03d", f)
    p seq
    yield f
    canvas = camera.render(world, true)
    puts "Saving..."
    canvas.to_ppm_file("seq/#{seq}.ppm")
  end
end

def single(camera, world, name)
  puts "Rendering..."
  canvas = camera.render(world, true)
  puts "Saving"
  canvas.to_ppm_file("#{name}.ppm")
  `open #{name}.ppm`
end

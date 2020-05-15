def animated(camera, world, frames = 100)
  puts "Rendering..."
  frames.times do |f|
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

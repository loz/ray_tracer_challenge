class PhysicsObject
  property position, velocity
  property shape : Shape

  def initialize(@position : Point, @velocity : Vector)
    @shape = sphere()
    @shape.material.color = red()
  end

  def apply(force)
    @velocity += force
    @position += @velocity

    if @position.y < 0
     @velocity *= -1.0
    end
    transform
  end

  def transform
    @shape.transform = translation(@position.x, @position.y, @position.z)
  end

end

class PhysicsWorld
  property gravity : Vector
  property objects

  def initialize()
    @objects = [] of PhysicsObject
    @gravity = vector(0.0, -0.98, 0.0)
  end

  def <<(object)
    @objects << object
  end

  def apply(world)
    @objects.each do |o|
      world.objects << o.shape
    end
  end

  def tick(seconds)
    g = @gravity * seconds
    @objects.each do |o|
      o.apply(g)
    end
  end
end

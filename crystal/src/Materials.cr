def material() 
  Materials.material()
end

module Materials
  def self.material()
    Materials::Default.new
  end

  class Base
    property color : RTuple
    property pattern : Pattern | Nil
    property ambient, diffuse, specular, shininess

    def initialize()
      @color = color(1.0, 1.0, 1.0)
      @ambient = 0.1
      @diffuse = 0.9
      @specular = 0.9
      @shininess = 200.0
    end

    def ==(other)
      @color == other.color &&
      @ambient == other.ambient &&
      @diffuse == other.diffuse &&
      @specular == other.specular &&
      @shininess == other.shininess
    end

    def lighting(light, position, eyev, normalv, in_shadow = false)
      effective_color = color * light.intensity 
      pattern.try do |pattern|
         effective_color = pattern.at(position) * light.intensity
      end

      lightv = (light.position - position).normalize

      e_ambient = effective_color * ambient

      return color(e_ambient) if in_shadow

      #light normal is relatied to angle of light + normal
      light_dot_normal = lightv.dot(normalv)
      if light_dot_normal < 0.0
        e_diffuse = black
	e_specular = black
      else
        e_diffuse = effective_color * diffuse * light_dot_normal 

	#Refect represigns angle of reflect + eye
	reflectv = (-lightv).reflect(normalv)
	reflect_dot_eye = reflectv.dot(eyev)

	if reflect_dot_eye <= 0.0
	  e_specular = black
	else
	  factor = reflect_dot_eye ** shininess
	  e_specular = light.intensity * specular * factor
	end
      end

      return color(e_ambient + e_diffuse + e_specular)
    end
  end

  class Default < Base
  end
end

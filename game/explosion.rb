class Explosion

  def initialize
    @projectils     = []
    @projectilTotal = 0
  end

  def draw
    @projectilTotal.times{|n|
      $camera.draw_this @projectils[n]
    }
  end

  def update
    @projectilTotal.times{|n|
      @projectils[n].update
      if @projectils[n].is_dead?
        @projectils[n] = @projectils[@projectilTotal - 1]
        @projectilTotal -= 1
      end
    }
  end

  def generate subject, size, amount, color, absolute=false
    amount.times {
      projectil = Projectil.new subject.x, subject.y, size, color
      if absolute
        projectil.velocity = rand(1000) / 1000.0 * 5.0
        projectil.set_angle(rand(Math::PI * 2000) / 1000.0)
      else
        projectil.direction = subject.direction.dup
        projectil.velocity = subject.velocity * (rand(30) / 100.0 + 0.2)
        projectil.rotate((rand(100) / 100.0) - 0.5)
      end
      @projectils[@projectilTotal] = projectil
      @projectilTotal += 1
    }
  end

end


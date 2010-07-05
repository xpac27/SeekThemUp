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

  def generate subject, size, amount
    amount.times {
      projectil = Projectil.new subject.x, subject.y, size
      projectil.velocity = subject.velocity
      projectil.velocity[0] /= rand(10) + 5
      projectil.velocity[1] /= rand(10) + 5
      projectil.velocity[0] -= rand(8) - 4
      projectil.velocity[1] -= rand(8) - 4
      @projectils[@projectilTotal] = projectil
      @projectilTotal += 1
    }
  end

end


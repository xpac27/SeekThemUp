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

  def generate subject, size, amount, color
    amount.times {
      projectil = Projectil.new subject.x, subject.y, size, color
      projectil.base_velocity_on subject
      @projectils[@projectilTotal] = projectil
      @projectilTotal += 1
    }
  end

end


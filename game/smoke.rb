class Smoke

  def initialize
    @puffs     = []
    @puffTotal = 0
  end

  def draw
    @puffTotal.times{|n|
      $camera.draw_this @puffs[n]
    }
  end

  def update
    @puffTotal.times{|n|
      @puffs[n].update
      if @puffs[n].is_dead?
        @puffs[n] = @puffs[@puffTotal - 1]
        @puffTotal -= 1
      end
    }
  end

  def generate subject, size, life, vx, vy
    puff = Puff.new subject.x, subject.y, size, life
    puff.direction = subject.direction.dup
    @puffs[@puffTotal] = puff
    @puffTotal += 1
  end

end


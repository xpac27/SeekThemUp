class Smoke

  def initialize subject
    @subject   = subject
    @puffs     = []
    @puffTotal = 0
  end

  def draw
		@puffTotal.times{|n|
			@puffs[n].draw
		}
  end

  def update
    @puffTotal.times{|n|
      @puffs[n].update
      if @puffs[n].is_dead
        @puffs[n] = @puffs[@puffTotal - 1]
        @puffTotal -= 1
      end
    }
	end

  def generate size, life, vx, vy
    puff = Puff.new @subject.x, @subject.y, size, life
		puff.velocity = @subject.velocity
    puff.translate vx, vy
    @puffs[@puffTotal] = puff
    @puffTotal += 1
  end

end


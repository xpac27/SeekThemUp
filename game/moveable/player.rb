class Player < Moveable

  def initialize(window, x, y, s)
    @smoke = []
    @smokeTotal = 0
		super(window, x, y, s)
	end

  def draw
    @smokeTotal.times{|n|
      @smoke[n].draw
    }
		@box.draw(0xFFFFFF00)
  end

  def update
    @smokeTotal.times{|n|
      @smoke[n].update
      if @smoke[n].is_dead
        @smoke[n] = @smoke[@smokeTotal-1]
        @smokeTotal -= 1
      end
    }
    super
  end

  def translate(x, y)
    puff = Smoke.new(@window, @x, @y, 8, 20)
    puff.velocity = @velocity
    puff.translate(x*-1, y*-1)
    @smoke[@smokeTotal] = puff
    @smokeTotal += 1
    super
  end

end


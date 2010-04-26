class Enemy < Moveable

	attr_writer :player

	@player

  def update
		if Tool::distance(self, @player) < 120
			translate((@player.x - @x) / (@player.x - @x).abs, (@player.y - @y) / (@player.y - @y).abs)
		else
			@direction = rand(10) if rand(30) == 1

			case @direction
				when 0 then translate(0, -1)
				when 1 then translate(1, -1)
				when 2 then translate(1, 0)
				when 3 then translate(1, 1)
				when 4 then translate(0, 1)
				when 5 then translate(-1, 1)
				when 6 then translate(-1, 0)
				when 7 then translate(-1, -1)
			end
		end

		super
  end

  def draw
    if @overlaps
      @box.draw(0xFFFF0000)
    else
      @box.draw(0xFFCCCCCC)
    end
  end

  def colide(item)
    #translate((box.left - rect.left)/2.0, (box.top - rect.top)/2.0)
    @overlaps = true
    @velocity = [item.velocity[0] * 1.2, item.velocity[1] * 1.2]
  end

end


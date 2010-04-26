# TODO this should < Rect
class Moveable

  attr_reader   :box, :x, :y, :size, :velocity
  attr_writer   :overlaps
  attr_accessor :speed, :acceleration, :friction

  def initialize(window, x, y, s)
    @window       = window
    @x            = x
    @y            = y
		@size         = s
    @speed        = 4
    @acceleration = 0.4
    @friction     = 0.1
    @velocity     = [0,0]
    @angle        = 0
    @box          = Rect.new(@window, @x, @y, s, s)
  end

  def update
    @overlaps = false
    @x = @box.x = @x + @velocity[0]
    @y = @box.y = @y + @velocity[1]

    @velocity[0] = (@velocity[0] - @friction) if (@velocity[0] > 0)
    @velocity[1] = (@velocity[1] - @friction) if (@velocity[1] > 0)
    @velocity[0] = (@velocity[0] + @friction) if (@velocity[0] < 0)
    @velocity[1] = (@velocity[1] + @friction) if (@velocity[1] < 0)
  end

  def draw
		@box.draw(0xFFCCCCCC)
  end

  def translate(x, y)
    @velocity[0] = @velocity[0] + @acceleration * x if @velocity[0].abs < @speed
    @velocity[1] = @velocity[1] + @acceleration * y if @velocity[1].abs < @speed
  end

  def rotate(a)
    @angle += a
  end

	def velocity=(v)
		@velocity = v.dup
	end

  def direction_x(a = 0)
    Gosu::offset_x(@angle + a, 1)
  end

  def direction_y(a = 0)
    Gosu::offset_y(@angle + a, 1)
  end

end


# TODO this should < Rect
class Moveable

  attr_reader   :box
  attr_writer   :overlaps
  attr_accessor :speed, :acceleration, :friction, :x, :y, :size, :velocity

  def initialize x, y, size
    @x            = x
    @y            = y
    @size         = size
    @speed        = 1
    @acceleration = 0.4
    @friction     = 0.1
    @velocity     = [0,0]
    @angle        = 0
    @box          = Rect.new @x, @y, @size, @size
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
    @box.draw
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

end


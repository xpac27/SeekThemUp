# TODO this should < Rect
class Moveable

  attr_reader   :box
  attr_accessor :speed, :acceleration, :friction, :x, :y, :size, :velocity

  def initialize x, y, size
    @x            = x
    @y            = y
    @tx           = 0
    @ty           = 0
    @size         = size
    @speed        = 1
    @acceleration = 0.4
    @friction     = 0.1
    @velocity     = [0,0]
    @angle        = 0
    @box          = Rect.new @x, @y, @size, @size
  end

  def update
    @x = @box.x = @x + @velocity[0]
    @y = @box.y = @y + @velocity[1]

    unless (@tx == 0 and @ty == 0)
      @tx /= Math.sqrt(@tx**2 + @ty**2)
      @ty /= Math.sqrt(@tx**2 + @ty**2)
      @velocity[0] = @velocity[0] + @acceleration * @tx if @velocity[0].abs < @tx.abs * @speed
      @velocity[1] = @velocity[1] + @acceleration * @ty if @velocity[1].abs < @ty.abs * @speed
      @tx = 0
      @ty = 0
    end

    @velocity[0] = (@velocity[0] - @friction) if (@velocity[0] > 0)
    @velocity[1] = (@velocity[1] - @friction) if (@velocity[1] > 0)
    @velocity[0] = (@velocity[0] + @friction) if (@velocity[0] < 0)
    @velocity[1] = (@velocity[1] + @friction) if (@velocity[1] < 0)
  end

  def draw
    @box.draw
  end

  def set_texture file
    @box.set_texture file
  end

  def translate(x, y)
    @tx = x unless x == 0
    @ty = y unless y == 0
  end

  def rotate(a)
    @angle += a
  end

  def distance_to(item)
    return @box.distance_to item.box
  end

end


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

  def set_texture file
    @box.set_texture file
  end

  def translate(x, y)
    x /= Math.sqrt(x**2 + y**2)
    y /= Math.sqrt(x**2 + y**2)
    @velocity[0] = @velocity[0] + @acceleration * x if @velocity[0].abs < x.abs * @speed
    @velocity[1] = @velocity[1] + @acceleration * y if @velocity[1].abs < y.abs * @speed
  end

  def rotate(a)
    @angle += a
  end

  def velocity=(v)
    @velocity = v.dup
  end

  def distance_to(item)
    return @box.distance_to item.box
  end

end


# TODO this should < Box
class Moveable

  attr_reader   :box
  attr_accessor :speed, :acceleration, :friction, :direction, :x, :y, :size, :velocity

  def initialize x, y, size
    @size         = size
    @speed        = 1.0
    @acceleration = 0.4
    @friction     = 0.1
    @velocity     = 0.0
    @move         = 0
    @direction    = Vector.new(1.0, 0.0)
    @box          = Box.new x, y, @size, @size
  end

  def x; @box.x; end
  def y; @box.y; end
  def x= value; @box.x = value; end
  def y= value; @box.y = value; end

  def update
    @box.x = @box.x + @velocity * @direction.x
    @box.y = @box.y + @velocity * @direction.y

    if @move != 0
      @velocity = @velocity + @acceleration * @move if @velocity < @speed && @velocity > -@speed
      @move = 0
    end

    if (@velocity < @acceleration and @velocity > -@acceleration)
      @velocity = 0
    else
      @velocity -= @friction if @velocity > 0
      @velocity += @friction if @velocity < 0
    end
  end

  def draw
    @box.draw
  end

  def set_texture file
    @box.set_texture file
  end

  def rotate(angle)
    @direction.rotate(angle)
    @box.set_angle(@direction.get_angle)
  end

  def set_angle(angle)
    @direction.set_angle(angle)
    @box.set_angle(@direction.get_angle)
  end

  def move_to(x, y)
    @direction.x = x - @box.x;
    @direction.y = y - @box.y;
    @direction.normalize
    move_forward
  end

  def move_forward
    @move = 1
  end

  def move_backward
    @move = -1
  end

  def distance_to(item)
    return @box.distance_to item.box
  end

end


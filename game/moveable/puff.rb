class Puff < Moveable

  def initialize x, y, size, life
    super x, y, rand(size) + size/4.0
    @life         = life
    @age          = 0.0
    @speed        = 10
    @acceleration = 0.1
    @friction     = 0
    @box.set_shape Rectangle.new
  end

  def update
    self.x = x + rand(6) - 3
    self.y = y + rand(6) - 3
    @age += 1
    @size += 1
    @box.set_size(@size, @size)
    move_backward
    super
  end

  def draw
    glColor4f 0.2, 0.2, 0.2, 0.4
    @box.draw
  end

  def is_dead?
    return (@age >= @life)
  end

end


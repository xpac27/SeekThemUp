class Puff < Moveable

  def initialize x, y, size, life
    super x, y, rand(size) + size/4
    @life         = life
    @age          = 0.0
    @speed        = 10
    @acceleration = 8
    @friction     = 3
  end

  def update
    @age += 1
    @x += rand(6) - 3
    @y += rand(6) - 3
    @size += 1
    @box.set_size(@size, @size)
    super
  end

  def draw
    glColor3f 0.2, 0.2, 0.2
    @box.draw
  end

  def is_dead?
    return (@age >= @life)
  end

end


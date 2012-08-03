class Bullet < Moveable

  def initialize x, y, size
    super x, y, size
    @speed        = 15
    @acceleration = 15
    @friction     = 0
    @box.set_shape Rectangle.new
  end

  def update
    move_forward
    super
  end

  def draw
    glColor3f 1, 1, 0
    @box.draw
  end

  def explode
    $explosion.generate self, 2, 10, :red
  end

end


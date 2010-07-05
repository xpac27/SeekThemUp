class Bullet < Moveable

  def initialize x, y, size
    super x, y, size
    @speed = 20
    @acceleration = 20
    @friction = 0
  end

  def draw
    glColor3f 1, 1, 0
    @box.draw
  end

end


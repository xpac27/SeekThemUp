class Bullet < Moveable

  def initialize x, y, size
    super x, y, size
    @speed = 15
    @acceleration = 15
    @friction = 0
  end

  def draw
    glColor3f 1, 1, 0
    @box.draw
  end

  def explode
    $explosion.generate self, 2, 20, :red
    $camera.shake 3
  end

end


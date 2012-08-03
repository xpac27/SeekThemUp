class Enemy < Moveable

  def initialize x, y, size
    super x, y, size
    @energy = size / 4
    @box.set_shape Rectangle.new
  end

  def update
    rotate(rand(10)) if rand(30) == 1
    move_forward
    super
  end

  def draw
    glColor3f 0.8, 0.4, 0.4
    @box.draw
  end

  def loose_energy
    @energy -= 1
  end

  def is_dead?
    if @energy <= 0
      $explosion.generate self, 2, (size - 8) * 5, :red, true
      true
    else
      false
    end
  end

end


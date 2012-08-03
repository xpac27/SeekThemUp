class Enemy < Moveable

  def initialize x, y, size
    super x, y, size
    @box.set_shape Rectangle.new
  end

  def update
    translate(rand(2) - 1, rand(2) - 1) if rand(30) == 1
    super
  end

  def draw
    glColor3f 0.8, 0.4, 0.4
    @box.draw
  end

end


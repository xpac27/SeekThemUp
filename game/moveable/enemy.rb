class Enemy < Moveable

  def initialize x, y, size
    super x, y, size
    @box.set_shape Rectangle.new
  end

  def update
    @direction = rand(10) if rand(30) == 1

    case @direction
      when 0 then translate(0, -1)
      when 1 then translate(1, -1)
      when 2 then translate(1, 0)
      when 3 then translate(1, 1)
      when 4 then translate(0, 1)
      when 5 then translate(-1, 1)
      when 6 then translate(-1, 0)
      when 7 then translate(-1, -1)
    end

    super
  end

  def draw
    glColor3f 0.8, 0.4, 0.4
    @box.draw
  end

end


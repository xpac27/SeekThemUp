class Energy < Moveable

  def initialize x, y, subject
    super x, y, 5
    @speed        = 0.8
    @acceleration = 0.06
    @friction     = 0.05
    @subject = subject
  end

  def update
    if distance_to(@subject) < 120
      translate(@subject.x - @x, @subject.y - @y)
    end
    super
  end

  def draw
    glColor3f 0.4, 0.4, 0.8
    @box.draw
  end

end


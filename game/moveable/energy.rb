class Energy < Moveable

  def initialize x, y, subject
    super x, y, 5
    @speed        = 100
    @acceleration = 0.1
    @friction     = 0.05
    @subject      = subject
    @locked       = false
    @box.set_shape Rectangle.new
  end

  def update
    if not @locked
      @locked = true if distance_to(@subject) < 150
    else
      move_to(@subject.x, @subject.y)
    end
    super
  end

  def draw
    glColor3f 0.4, 0.4, 0.8
    @box.draw
  end

end


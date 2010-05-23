class Player < Moveable

  def initialize
    super 0, 0, 16
    @speed        = 8
    @acceleration = 0.08
    @friction     = 0.02
    @smoke        = Smoke.new self
	end

  def draw
    glColor3f 1, 1, 1
    @box.draw
    @smoke.draw
  end

  def update
    @smoke.update
    super
  end

  def move_foreward
    translate 0, -1
    @smoke.generate 10, 20, 0, 2
  end

  def move_backward
    translate 0, 1
    @smoke.generate 10, 20, 0, -2
  end

  def move_left
    translate -1, 0
    @smoke.generate 10, 20, 2, 0
  end

  def move_right
    translate 1, 0
    @smoke.generate 10, 20, -2, 0
  end

  #def turn_right
    #rotate(5)
    #translate(direction_x(40) * 0.6, direction_y(40) * 0.6)
    #@smoke.generate(4, 15, direction_x(-140), direction_y(-140))
  #end

  #def turn_left
    #rotate(-5)
    #translate(direction_x(-40) * 0.6, direction_y(-40) * 0.6)
    #@smoke.generate(4, 15, direction_x(140), direction_y(140))
  #end

end


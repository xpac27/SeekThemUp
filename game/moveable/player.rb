class Player < Moveable

  def initialize(window, x, y, s)
		super(window, x, y, s)
    @speed        = 5
    @acceleration = 0.08
    @friction     = 0.02
    @smoke        = Smoke.new(window, self)
    @sprite       = Gosu::Image.new(@window, 'game/media/player.png', true)
	end

  def draw
    @sprite.draw_rot(@x - @window.camera.x, @y - @window.camera.y, 1, @angle)
    @smoke.draw
  end

  def update
    @smoke.update
    super
  end

  def move_foreward
    @smoke.draw
  end

  def update
    @smoke.update
    super
  end

  def move_foreward
    translate(direction_x, direction_y)
    @smoke.generate(10, 20, direction_x * -1.2, direction_y * -1.2)
  end

  def turn_right
    rotate(5)
    translate(direction_x(40) * 0.6, direction_y(40) * 0.6)
    @smoke.generate(4, 15, direction_x(-140), direction_y(-140))
  end

  def turn_left
    rotate(-5)
    translate(direction_x(-40) * 0.6, direction_y(-40) * 0.6)
    @smoke.generate(4, 15, direction_x(140), direction_y(140))
  end

end


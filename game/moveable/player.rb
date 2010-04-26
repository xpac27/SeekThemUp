class Player < Moveable

  def initialize(window, x, y, s)
		super(window, x, y, s)
    @speed        = 5
    @acceleration = 0.08
    @friction     = 0.02
    @smoke        = Smoke.new(window, self)
	end

  def draw
		@box.draw(0xFFFFFF00)
    @smoke.draw
  end

  def update
    @smoke.update
    super
  end

  def translate(vx, vy)
    @smoke.generate(8, 20, vx * -1.2, vy * -1.2)
    super
  end

end


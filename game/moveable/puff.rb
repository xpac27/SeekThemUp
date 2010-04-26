class Puff < Moveable

  attr_reader :is_dead

  def initialize(window, x, y, s, l)
		super(window, x, y, rand(s) + s/4)
		@life         = l
		@age          = 0.0
    @speed        = 10
    @acceleration = 6
    @friction     = 0.8
		@is_dead      = false
	end

	def update
		@age += 1
		@x += rand(6) - 3
		@y += rand(6) - 3
		@size += 1
		@box.set_size(@size, @size)
		@is_dead = true if @age >= @life
		super
	end

  def draw
		@box.draw(Gosu::Color.new((60 * (1 - (@age / @life))).floor, 255, 255, 255))
  end

end


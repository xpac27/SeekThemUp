class Puff < Moveable

  attr_reader :is_dead

  def initialize x, y, size, life
		super x, y, rand(size) + size/4
		@life         = life
		@age          = 0.0
    @speed        = 10
    @acceleration = 8
    @friction     = 3
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
    glColor3f 0.2, 0.2, 0.2
		@box.draw
  end

end


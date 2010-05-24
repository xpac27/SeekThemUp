class Player < Moveable

	attr_reader :bullet_list
	attr_accessor :shooting

  def initialize
    super 0, 0, 16
    @speed        = 6
    @acceleration = 0.24
    @friction     = 0.10
    @smoke        = Smoke.new self
    @bullet_list  = []
		@shooting     = false
		@latest_shoot = 0
	end

  def draw
    @smoke.draw
		@bullet_list.each {|item| item.draw}
    glColor3f 1, 1, 1
    super
  end

  def update
    @smoke.update
		@bullet_list.each {|item|
			if $camera.is_visible? item then
				item.update
			else
				@bullet_list.delete item
			end
		}
		if @shooting then
			shoot if $clock.lifetime - @latest_shoot > 200
		else
				@latest_shoot = 0
		end
    super
  end

  def move_foreward
    translate 0, -1
    @smoke.generate 8, 12, 0, 1.5
  end

  def move_backward
    translate 0, 1
    @smoke.generate 8, 12, 0, -1.5
  end

  def move_left
    translate -1, 0
    @smoke.generate 8, 12, 1.5, 0
  end

  def move_right
    translate 1, 0
    @smoke.generate 8, 12, -1.5, 0
  end

  def shoot
		dx = $cursor.x - @x
		dy = $cursor.y - @y
		mag = Math.sqrt(dx**2 + dy**2)
		dx = dx/mag
		dy = dy/mag
		@bullet_list += [Bullet.new @x, @y, 2, [dx, dy]]
		@latest_shoot = $clock.lifetime
	end

end


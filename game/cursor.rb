class Cursor

  attr_writer :x, :y

  def initialize
    @x = 0
    @y = 0
	end

  def draw
    glPushMatrix
      glTranslatef @x, @y, 0
    glPopMatrix
  end

  def x
    @x + ($camera.x - 400)
  end

  def y
    @y + ($camera.y - 300)
  end

end


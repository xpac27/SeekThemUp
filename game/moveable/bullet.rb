class Bullet

  attr_reader :box
  attr_accessor :speed

  def initialize x, y, size, direction
    @x = x
    @y = y
    @box = Rect.new @x, @y, size, size
    @direction = direction
    @speed = 20
  end

  def update
    @box.x = @x += @direction[0]*@speed
    @box.y = @y += @direction[1]*@speed
  end

  def draw
    glColor3f 1, 1, 0
    @box.draw
  end

end


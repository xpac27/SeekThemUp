class Player

  def initialize(window)
    @window = window
    @speed = 2
    @size = 32
    @x = window.width / 2
    @y = window.height / 2
  end

  def update
  end

  def draw
    @window.draw_quad(top, left, 0xAAFF0000, top, right, 0xAAFF0000, bottom, left, 0xAAFF0000, bottom, right, 0xAAFF0000)
  end

  def translate(x, y)
    nx = @x + x * @speed
    ny = @y + y * @speed

    @x = nx if nx < @window.width - @size/2 and nx > @size/2
    @y = ny if ny < @window.height - @size/2 and ny > @size/2
  end

  def top;    @x - @size/2; end
  def left;   @y - @size/2; end
  def bottom; @x + @size/2; end
  def right;  @y + @size/2; end

end


class Enemy

  def initialize(window)
    @sprite = Gosu::Image.new(window, 'game/media/enemy.png')
    @window = window
    @speed = 0.5
    @size = 32
    @direction = 0
    @x = rand(window.width - @size) + @size/2
    @y = rand(window.height - @size) + @size/2
  end

  def update
    @direction = rand(7) if rand(80) == 1

    case @direction
      when 0 then translate(0, -1)
      when 1 then translate(1, -1)
      when 2 then translate(1, 0)
      when 3 then translate(1, 1)
      when 4 then translate(0, 1)
      when 5 then translate(-1, 1)
      when 6 then translate(-1, 0)
      when 7 then translate(-1, -1)
    end
  end

  def draw
    @sprite.draw(@x - @size/2, @y - @size/2, 2)
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


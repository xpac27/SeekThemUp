class Enemy

  def initialize(window)
    @sprite = Gosu::Image.new(window, 'game/media/enemy.png')
    @window = window
    @speed = 0.5
    @direction = 0
    @x = rand(window.width - 32) + 16
    @y = rand(window.height - 32) + 16
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
    @sprite.draw(@x - 16, @y - 16, 1)
  end

  def translate(x, y)
    nx = @x + x * @speed
    ny = @y + y * @speed

    @x = nx if nx < @window.width - 16 and nx > 16
    @y = ny if ny < @window.height - 16 and ny > 16
  end

end


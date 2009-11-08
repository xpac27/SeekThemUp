class Player

  def initialize(window)
    @sprite = Gosu::Image.new(window, 'game/media/player.png')
    @window = window
    @speed = 2
    @x = window.width / 2
    @y = window.height / 2
  end

  def update
  end

  def draw
    @sprite.draw(@x - 16, @y - 16, 2)
  end

  def translate(x, y)
    nx = @x + x * @speed
    ny = @y + y * @speed

    @x = nx if nx < @window.width - 16 and nx > 16
    @y = ny if ny < @window.height - 16 and ny > 16
  end

end


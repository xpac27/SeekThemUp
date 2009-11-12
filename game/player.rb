class Player

  attr_reader :box
  attr_writer :overlaps

  def initialize(window)
    @window = window
    @x = window.width / 2
    @y = window.height / 2
    @box = Rect.new(@window, @x, @y, 32, 32)
    @speed = 2
  end

  def update
    @overlaps = false
  end

  def draw
    if @overlaps
      @box.draw(0xAAFF0000)
    else
      @box.draw(0xAA00FF00)
    end
  end

  def translate(x, y)
    nx = @x + x * @speed
    ny = @y + y * @speed

    # TODO: use box structure to do this test
    @x = @box.x = nx if (nx < @window.width - 32/2 and nx > 32/2)
    @y = @box.y = ny if (ny < @window.height - 32/2 and ny > 32/2)
  end

end


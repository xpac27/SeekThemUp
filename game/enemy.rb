class Enemy

  attr_accessor :overlaps, :box

  def initialize(window)
    @window = window
    @x = rand(window.width - 16) + 16/2
    @y = rand(window.height - 16) + 16/2
    @box = Rect.new(@window, @x, @y, 16, 16)
    @speed = 0.4
    @direction = 0
    @overlaps = false
  end

  def update
    @overlaps = false
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
    if @overlaps
      @box.draw(0xAAFF0000)
    else
      @box.draw(0xAAFFFFFF)
    end
  end

  def translate(x, y)
    nx = @x + x * @speed
    ny = @y + y * @speed

    # TODO: use box structure to do this test
    @x = @box.x = nx if nx < @window.width - 16/2 and nx > 16/2
    @y = @box.y = ny if ny < @window.height - 16/2 and ny > 16/2
  end

end


class Enemy

  attr_accessor :overlaps

  def initialize(window)
    @window = window
    @speed = 0.4
    @size = 16
    @direction = 0
    @overlaps = false
    @x = rand(window.width - @size) + @size/2
    @y = rand(window.height - @size) + @size/2
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
      @window.draw_quad(top, left, 0xAAFF0000, top, right, 0xAAFF0000, bottom, left, 0xAAFF0000, bottom, right, 0xAAFF0000)
    else
      @window.draw_quad(top, left, 0xAAFFFFFF, top, right, 0xAAFFFFFF, bottom, left, 0xAAFFFFFF, bottom, right, 0xAAFFFFFF)
    end
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


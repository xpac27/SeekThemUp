class Vector

  attr_accessor :x, :y

  def initialize x=1, y=1
    @x = x
    @y = y
  end

  def normalize
    hold = magnitude
    @x /= hold
    @y /= hold
  end

  def magnitude
    Math.sqrt(@x**2 + @y**2)
  end

  def set_angle(a)
    @x = Math.cosd(a)
    @y = Math.sind(a)
  end

  def rotate(delta)
    @x = (@x * Math.cos(delta)) - (@y * Math.sin(delta));
    @y = (@x * Math.sin(delta)) + (@y * Math.cos(delta));
    normalize
  end

  def get_angle
    if @y < 0
      Math.acos(@x * -1) * (180 / Math::PI) + 180
    else
      Math.acos(@x) * (180 / Math::PI)
    end
  end

end


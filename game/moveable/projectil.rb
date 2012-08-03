class Projectil < Moveable

  def initialize x, y, size, color
    super x, y, size
    @color = color
    @alpha = 1.0
    @box.set_shape Rectangle.new
  end

  def update
    move_forward
    super
  end

  def draw
    case @color
      when :red
        glColor4f 1, 0, 0, @alpha
      when :green
        glColor4f 0, 1, 0, @alpha
      when :blue
        glColor4f 0, 0, 0, @alpha
      when :yellow
        glColor4f 1, 1, 0, @alpha
      when :white
        glColor4f 1, 1, 0, @alpha
    end

    @alpha -= @alpha / 20

    @box.draw
  end

  def is_dead?
    return (@velocity.abs < @acceleration || @alpha < 0.05)
  end

end



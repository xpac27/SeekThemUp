class Box

  attr_reader :x, :y, :px, :py, :top, :right, :bottom, :left, :width, :height, :alf_height, :alf_width

  def initialize x, y, width, height
    @x = @px = x
    @y = @py = y
    @angle = 0
    set_size(width, height)
  end

  def set_shape shape
    @shape = shape
    @shape.set_width @width
    @shape.set_height @height
  end

  def set_angle angle
    @angle = angle
  end

  def draw
    if @shape
      glPushMatrix
        glTranslatef @x, @y, 0
        glRotatef @angle, 0, 0, 1
        @shape.draw
      glPopMatrix
    end
  end

  def set_texture file
    @surface = Surface.load file
  end

  def outline
    glPushMatrix
      glTranslatef @x, @y, 0

      glBegin GL_LINES
        glVertex2i  @alf_width,  @alf_height
        glVertex2i -@alf_width,  @alf_height

        glVertex2i -@alf_width,  @alf_height
        glVertex2i -@alf_width, -@alf_height

        glVertex2i -@alf_width, -@alf_height
        glVertex2i  @alf_width, -@alf_height

        glVertex2i  @alf_width, -@alf_height
        glVertex2i  @alf_width,  @alf_height
      glEnd
    glPopMatrix
  end

  def set_size(width, height)
    set_width(width)
    set_height(height)
  end

  def set_width(value)
    @width = value
    @alf_width = @width / 2
    @left = @x - @alf_width
    @right = @x + @alf_width
    @shape.set_width value if @shape
  end

  def set_height(value)
    @height = value
    @alf_height = @height / 2
    @top = @y - @alf_height
    @bottom = @y + @alf_height
    @shape.set_height value if @shape
  end

  def x=(value)
    @px = @x
    @x = value
    @left = @x - @alf_width
    @right = @x + @alf_width
  end

  def y=(value)
    @py = @y
    @y = value
    @top = @y - @alf_height
    @bottom = @y + @alf_height
  end

  def union!(box)
    @top = box.top if box.top < @top
    @left = box.left if box.left < @left
    @bottom = box.bottom if box.bottom > @bottom
    @right = box.right if box.right > @right
    @x = (@left + @right) * 0.5
    @y = (@top + @bottom) * 0.5
    set_width(@right - @left)
    set_height(@bottom - @top)
  end

  def touch?(box)
    (
      (@top >= box.top and @top <= box.bottom) or
      (@bottom >= box.top and @bottom <= box.bottom) or
      (@top < box.top and @bottom > box.bottom)
    ) and (
      (@left >= box.left and @left <= box.right) or
      (@right >= box.left and @right <= box.right) or
      (@left < box.left and @right > box.right)
    )
  end

  def overlaps?(box)
    (box.right >= @left and box.left <= @right and box.bottom >= @top and box.top <= @bottom)
  end

  def colided?(box)
    diboxion = [box.px, box.py, box.x - (@x-@px), box.y - (@y-@py)]
    left      = @px - @alf_width - box.alf_width
    right     = @px + @alf_width + box.alf_width
    top       = @py - @alf_height - box.alf_height
    bottom    = @py + @alf_height + box.alf_height
    [
      [left,  top,    right, top   ],
      [right, top,    right, bottom],
      [left,  bottom, left,  top   ],
      [right, bottom, left,  bottom],
    ].each{|p|
      return true if (segments_colide? p[0], p[1], p[2], p[3], direction[0], direction[1], direction[2], direction[3])
    }
    return false
  end

  #TODO put this in a Segement class using a Vector class
  def segments_colide? ax, ay, bx, by, cx, cy, dx, dy
      return false if (ax == bx and ay == by)
      return false if (cx == dx and cy == dy)
      s1x = ax-bx;
      s1y = ay-by;
      s2x = cx-dx;
      s2y = cy-dy;
      s = (-s1y*(bx-dx) + s1x*(by-dy)) / (-s2x*s1y + s1x*s2y);
      t = ( s2x*(by-dy) - s2y*(bx-dx)) / (-s2x*s1y + s1x*s2y);
      return (s >= 0 and s <= 1 and t >= 0 and t <= 1)
  end

  def nw_quadrant
    Box.new @x - @alf_width/2, @y - @alf_height/2, @width/2, @height/2
  end

  def ne_quadrant
    Box.new @x + @alf_width/2, @y - @alf_height/2, @width/2, @height/2
  end

  def se_quadrant
    Box.new @x + @alf_width/2, @y + @alf_height/2, @width/2, @height/2
  end

  def sw_quadrant
    Box.new @x - @alf_width/2, @y + @alf_height/2, @width/2, @height/2
  end

  def distance_to(box)
    return Math.sqrt((@x - box.x)**2 + (@y - box.y)**2)
  end

end

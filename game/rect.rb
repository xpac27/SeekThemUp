class Rect

  attr_reader :x, :y, :px, :py, :top, :right, :bottom, :left, :width, :height

  def initialize x, y, width, height
    @x = @px = x
    @y = @py = y
    set_size(width, height)
  end

  def draw
    glPushMatrix
      glTranslatef @x, @y, 0
      if @surface
        glBindTexture   GL_TEXTURE_2D, glGenTextures(1)[0]
        glTexImage2D    GL_TEXTURE_2D, 0, GL_RGBA, @surface.w, @surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, @surface.pixels
        glTexParameter  GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
        glTexParameter  GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
        glEnable        GL_TEXTURE_2D
        glBegin         GL_QUADS
          glTexCoord2i  1,           0
          glVertex2i    @alf_width, -@alf_height
          glTexCoord2i  1,           1
          glVertex2i    @alf_width,  @alf_height
          glTexCoord2i  0,           1
          glVertex2i   -@alf_width,  @alf_height
          glTexCoord2i  0,           0
          glVertex2i   -@alf_width, -@alf_height
        glEnd
        glDeleteTextures 1
      else
        glBegin GL_QUADS
          glVertex2i    @alf_width, -@alf_height
          glVertex2i    @alf_width,  @alf_height
          glVertex2i   -@alf_width,  @alf_height
          glVertex2i   -@alf_width, -@alf_height
        glEnd
      end
    glPopMatrix
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
  end

  def set_height(value)
    @height = value
    @alf_height = @height / 2
    @top = @y - @alf_height
    @bottom = @y + @alf_height
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

  def union!(rect)
    @top = rect.top if rect.top < @top
    @left = rect.left if rect.left < @left
    @bottom = rect.bottom if rect.bottom > @bottom
    @right = rect.right if rect.right > @right
    @x = (@left + @right) * 0.5
    @y = (@top + @bottom) * 0.5
    set_width(@right - @left)
    set_height(@bottom - @top)
  end

  def overlaps?(rect)
    (rect.right >= @left and rect.left <= @right and rect.bottom >= @top and rect.top <= @bottom)
  end

  def meeted?(rect)
    # create a new rect representing this one at the previous tick
    prev = Rect.new @px, @py, @width, @height

    # define trajectories from each of this rect's corners to the previous rect's oposit corners
    points = [
      {:x => @left,  :y => @top,    :px => prev.bottom, :py => prev.right},
      {:x => @right, :y => @top,    :px => prev.left,   :py => prev.bottom},
      {:x => @left,  :y => @bottom, :px => prev.right,  :py => prev.top},
      {:x => @right, :y => @bottom, :px => prev.left,   :py => prev.top},
    ]

    # test each trajectories against the rect's center's trajectory
    points.each{|p|
      s1x = p[:x] - p[:px];
      s1y = p[:y] - p[:py];
      s2x = rect.x - rect.px;
      s2y = rect.y - rect.py;
      s = (-s1y*(p[:px]-rect.px) + s1x*(p[:py]-rect.py)) / (-s2x*s1y + s1x*s2y);
      t = ( s2x*(p[:py]-rect.py) - s2y*(p[:px]-rect.px)) / (-s2x*s1y + s1x*s2y);

      # did the trajectories crossed ?
      return (s >= 0 and s <= 1 and t >= 0 and t <= 1)
    }
    return false
  end

  def nw_quadrant
    Rect.new @x - @alf_width/2, @y - @alf_height/2, @width/2, @height/2
  end

  def ne_quadrant
    Rect.new @x + @alf_width/2, @y - @alf_height/2, @width/2, @height/2
  end

  def se_quadrant
    Rect.new @x + @alf_width/2, @y + @alf_height/2, @width/2, @height/2
  end

  def sw_quadrant
    Rect.new @x - @alf_width/2, @y + @alf_height/2, @width/2, @height/2
  end

  def distance_to(rect)
    return Math.sqrt((@x - rect.x)**2 + (@y - rect.y)**2)
  end

end

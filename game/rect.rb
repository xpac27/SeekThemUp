class Rect

  attr_reader :x, :y, :px, :py, :top, :right, :bottom, :left, :width, :height, :alf_heIght, :alf_width

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

  def colided?(rect)
    direction = [rect.px, rect.py, rect.x - (self.x-self.px), rect.y - (self.y-self.py)]
    left      = self.px - self.alf_width
    right     = self.px + self.alf_width
    top       = self.py - self.alf_width
    bottom    = self.py + self.alf_width
    [
      [left,  top,    right, top   ],
      [right, top,    right, bottom],
      [left,  bottom, left,  top   ],
      [right, bottom, left,  bottom],
    ].each{|p|
      return true if (segments_colide? p[0], p[1], p[2], p[3], direction[0], direction[1], direction[2], direction[3])
    }
  end

  #TODO put this in a Segement class using a Vector class
  def segments_colide? ax, ay, bx, by, cx, cy, dx, dy
      return if (ax == bx and ay == by)
      return if (cx == dx and cy == dy)
      s1x = ax-bx;
      s1y = ay-by;
      s2x = cx-dx;
      s2y = cy-dy;
      s = (-s1y*(bx-dx) + s1x*(by-dy)) / (-s2x*s1y + s1x*s2y);
      t = ( s2x*(by-dy) - s2y*(bx-dx)) / (-s2x*s1y + s1x*s2y);
      return (s >= 0 and s <= 1 and t >= 0 and t <= 1)
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

class Shape

  def set_width(value)
    @alf_width = value / 2.0
  end

  def set_height(value)
    @alf_height = value / 2.0
  end

  def draw
    if @surface
      glBindTexture   GL_TEXTURE_2D, glGenTextures(1)[0]
      glTexImage2D    GL_TEXTURE_2D, 0, GL_RGBA, @surface.w, @surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, @surface.pixels
      glTexParameter  GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
      glTexParameter  GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
      glEnable        GL_TEXTURE_2D
      glBegin         @gl_type
        @segment_list.each{|segment|
          glTexCoord2i segment[1][0], segment[1][1]
          glVertex2f segment[0][0] * @alf_width, segment[0][1] * @alf_height
        }
      glEnd
      glDeleteTextures 1
    else
      glBegin @gl_type
        @segment_list.each{|segment|
          glVertex2f segment[0][0] * @alf_width, segment[0][1] * @alf_height
        }
      glEnd
    end
  end

end




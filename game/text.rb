class Text

  def initialize file
    sfont = SFont.new file
    @letters = {}

    SFont::default_glyphs.each{|item|
      surface = sfont.render(item)
      #surface.set_colorkey [0,0,0,255]     # attempt to force colorkey
      #surface = surface.to_display_alpha   # attempt to force alpha
      @letters[item] = {
        :surface => surface,
        :width   => sfont.string_width(item)
      }
    }
  end

  def print x, y, string
    glColor3f 1, 1, 1

    glPushMatrix
      glTranslatef x, y, 0

      string.each_char {|char|
        if @letters[char]
          glTranslatef    @letters[char][:width], 0, 0
          glBindTexture   GL_TEXTURE_2D, glGenTextures(1)[0]
          glTexImage2D    GL_TEXTURE_2D, 0, GL_RGBA, @letters[char][:surface].w, @letters[char][:surface].h, 0, GL_RGBA, GL_UNSIGNED_BYTE, @letters[char][:surface].pixels
          glTexParameter  GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
          glTexParameter  GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
          glEnable        GL_TEXTURE_2D
          glBegin         GL_QUADS
            glTexCoord2i  1,                       0
            glVertex2i    @letters[char][:width],  0
            glTexCoord2i  1,                       1
            glVertex2i    @letters[char][:width],  16
            glTexCoord2i  0,                       1
            glVertex2i    0,                       16
            glTexCoord2i  0,                       0
            glVertex2i    0,                       0
          glEnd
          glDeleteTextures 1
        else
          glTranslatef 10, 0, 0
        end
      }

    glPopMatrix
  end

end


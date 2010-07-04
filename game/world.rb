class World

  def initialize
  end

  def draw from_camera
    glPushMatrix
      glTranslatef (from_camera.x%32)*-1, (from_camera.y%32)*-1, 0

      # grey background
      glColor3f 0.1, 0.1, 0.1

      # draw vertical lines
      (800/32 + 1).times{|n|
        glBegin GL_LINES
          glVertex2f n*32, 0
          glVertex2f n*32, 632
        glEnd
      }

      # draw horizontal lines
      (600/32 + 2).times{|n|
        glBegin GL_LINES
          glVertex2f 0,   n*32
          glVertex2f 832, n*32
        glEnd
      }
    glPopMatrix
  end

end


class Map

  def initialize scale
    @discovered = {}
    @scale      = scale
    @alf_scale  = scale / 2
  end

  def draw_from camera
    glPushMatrix
      glTranslatef (-camera.x + 400), (-camera.y + 300), 0
      @discovered.each_key{|key|
        data = key.split 'x'
        glPushMatrix
          glTranslatef data[0].to_i * @scale, data[1].to_i * @scale, 0
          glColor4f 1, 1, 1, 0.1
          glBegin GL_QUADS
            glVertex2i    @alf_scale, -@alf_scale
            glVertex2i    @alf_scale,  @alf_scale
            glVertex2i   -@alf_scale,  @alf_scale
            glVertex2i   -@alf_scale, -@alf_scale
          glEnd
        glPopMatrix
      }
    glPopMatrix
  end

  def get_key x, y
    position = get_position x, y
    return position[0].to_s + 'x' + position[1].to_s
  end

  def get_position x, y
    x = ((x + @alf_scale) / @scale).floor
    y = ((y + @alf_scale) / @scale).floor
    return [x, y]
  end

  def get_random_position x, y
    position = get_position x, y
    x = position[0] * @scale + rand(@scale) - @alf_scale
    y = position[1] * @scale + rand(@scale) - @alf_scale
    return [x, y]
  end

  def get_difficulty x, y
    return (Math.sqrt(x**2 + y**2) / @alf_scale).floor.abs
  end

  def is_discoverd x, y
    key = get_key x, y
    if not @discovered[key]
      @discovered[key] = true
      return false
    else
      return true
    end
  end

  def generate_enemies x, y
    enemies  = []
    get_difficulty(x, y).times {
      position = get_random_position x, y
      enemy              = Enemy.new(position[0], position[1], 8)
      enemy.speed        = (rand(100) / 100.0) * 0.4 + 0.1
      enemy.acceleration = (rand(100) / 100.0) * 0.02 + 0.015
      enemy.friction     = (rand(100) / 100.0) * 0.01 + 0.002
      enemy.player       = @player
      enemies << enemy
    }
    return enemies
  end

end



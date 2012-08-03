class Player < Moveable

  attr_reader :bullet_list, :energy

  def initialize
    super 0, 0, 16
    @energy       = 5
    @speed        = 5
    @acceleration = 0.60
    @friction     = 0.30
    @bullet_list  = []
    @latest_shoot = 0
    @box.set_shape Triangle.new
    $gui.set_info('energy', @energy)
  end

  def draw
    @bullet_list.each {|item| item.draw}
    glColor3f 1, 1, 1
    super
  end

  def update
    @bullet_list.each {|bullet|
      bullet.update
      @bullet_list.delete bullet unless $camera.is_visible? bullet
    }
    super
  end

  def move_forward
    $smoke.generate self, 8, 25, 0, -1
    super
  end

  def rotate_left
    rotate -0.1
  end

  def rotate_right
    rotate 0.1
  end

  def shoot
    return unless $clock.lifetime - @latest_shoot > 100
    dx = $cursor.x - x
    dy = $cursor.y - y
    mag = Math.sqrt(dx**2 + dy**2)
    dx = dx/mag
    dy = dy/mag

    bullet = Bullet.new x, y, 5
    bullet.translate $cursor.x, $cursor.y

    @bullet_list += [bullet]
    @latest_shoot = $clock.lifetime
  end

  def gain_energy
    @energy += 1
    $gui.set_info('energy', @energy)
  end

  def loose_energy
    @energy -= 1
    $explosion.generate self, 2, 2, :white
    $camera.shake 5
    $gui.set_info('energy', @energy)
  end

end


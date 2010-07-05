class Player < Moveable

  attr_reader :bullet_list

  def initialize
    super 0, 0, 16
    @speed        = 6
    @acceleration = 0.24
    @friction     = 0.10
    @bullet_list  = []
    @latest_shoot = 0
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

  def move_foreward
    translate 0, -1
    $smoke.generate self, 8, 12, 0, 1.5
  end

  def move_backward
    translate 0, 1
    $smoke.generate self, 8, 12, 0, -1.5
  end

  def move_left
    translate -1, 0
    $smoke.generate self, 8, 12, 1.5, 0
  end

  def move_right
    translate 1, 0
    $smoke.generate self, 8, 12, -1.5, 0
  end

  def shoot
    return unless $clock.lifetime - @latest_shoot > 100
    @latest_shoot = 0
    dx = $cursor.x - @x
    dy = $cursor.y - @y
    mag = Math.sqrt(dx**2 + dy**2)
    dx = dx/mag
    dy = dy/mag
    @bullet_list += [Bullet.new @x, @y, 5, [dx, dy]]
    @latest_shoot = $clock.lifetime
  end

end


class Projectil < Moveable

  def draw
    glColor3f 1, 0, 0
    @box.draw
  end

  def is_dead?
    return (@velocity[0].abs < @acceleration && @velocity[1].abs < @acceleration)
  end

end



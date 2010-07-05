class Game

  def initialize
    @quadtree   = Quadtree.new
    @world      = World.new
    @player     = Player.new
    @enemy_list = []
    200.times {
      enemy              = Enemy.new(100, 100, 8)
      enemy.speed        = (rand(100) / 100.0) * 0.4 + 0.1
      enemy.acceleration = (rand(100) / 100.0) * 0.02 + 0.015
      enemy.friction     = (rand(100) / 100.0) * 0.01 + 0.002
      enemy.player       = @player
      @enemy_list += [enemy]
    }

    $camera = Camera.new

    $camera.set_subject @player
    $camera.set_background @world
    $camera.add_character @player
    $camera.add_character @enemy_list

    $smoke = Smoke.new
  end

  def handle_keys list
    list.each{|key|
      case key
        when :mouse_left : @player.shoot
        when :w          : @player.move_foreward
        when :s          : @player.move_backward
        when :a          : @player.move_left
        when :d          : @player.move_right
      end
    }
  end

  def update
    $camera.update
    $smoke.update

    @player.update
    @enemy_list.each{|item|
      item.update
    }

    @quadtree.update(@enemy_list, $camera.box, 0)
    @quadtree.hit(@player.box).each{|item|
      $camera.shake 5
      break
    }

    @player.bullet_list.each{|bullet|
      @quadtree.hit(bullet.box).each{|enemy|
        $camera.shake 3
        $camera.remove_character enemy
        @enemy_list.delete enemy
        @player.bullet_list.delete bullet
        break
      }
    }
  end

  def draw
    $camera.draw
    $smoke.draw
    #@quadtree.draw
  end

end


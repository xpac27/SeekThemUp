class Game

  def initialize
    @quadtree_enemy  = Quadtree.new
    @quadtree_energy = Quadtree.new
    @world           = World.new
    @player          = Player.new
    @energy_list     = []
    @enemy_list      = []
    200.times {
      enemy              = Enemy.new(100, 100, 8)
      enemy.speed        = (rand(100) / 100.0) * 0.4 + 0.1
      enemy.acceleration = (rand(100) / 100.0) * 0.02 + 0.015
      enemy.friction     = (rand(100) / 100.0) * 0.01 + 0.002
      enemy.player       = @player
      @enemy_list += [enemy]
    }

    $camera.set_subject @player
    $camera.set_background @world
    $camera.append_character @player
    $camera.append_character @enemy_list
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
    $explosion.update

    @player.update
    @enemy_list.each {|item|
      item.update
    }
    @energy_list.each {|item|
      item.update
    }

    @quadtree_enemy.update(@enemy_list, $camera.box)
    @quadtree_enemy.hit(@player.box).each {|enemy|
      $camera.shake 5
      break
    }
    @player.bullet_list.each {|bullet|
      @quadtree_enemy.hit(bullet.box).each {|enemy|
        $explosion.generate bullet, 2, 20
        $camera.shake 3
        $camera.remove_character enemy
        @enemy_list.delete enemy
        @player.bullet_list.delete bullet
        energy = Energy.new enemy.x, enemy.y, @player
        $camera.prepend_character energy
        @energy_list += [energy]
        break
      }
    }

    @quadtree_energy.update(@energy_list, $camera.box, 0, @player)
    @quadtree_energy.hit(@player.box).each {|energy|
      $camera.remove_character energy
      @energy_list.delete energy
      break
    }
  end

  def draw
    $smoke.draw
    $camera.draw
    $explosion.draw
    @quadtree_enemy.draw 0.2, 0, 0
    @quadtree_energy.draw 0, 0, 0.2
  end

end


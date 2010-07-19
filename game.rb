class Game

  def initialize
    @quadtree_enemy  = Quadtree.new
    @quadtree_energy = Quadtree.new
    @world           = World.new
    @map             = Map.new 400
    @player          = Player.new
    @energy_list     = []
    @enemy_list      = []

    #@player.set_texture 'game/media/player.png'

    $camera.set_subject @player
    $camera.add_background @world
    $camera.add_background @map
    $camera.append_character @player
  end

  def handle_keys list
    list.each{|key|
      case key
        when :mouse_left : @player.shoot
        when :w          : @player.move_forward
        when :s          : @player.move_backward
        when :a          : @player.rotate_left
        when :d          : @player.rotate_right
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

    check_collisions
    check_map
  end

  def draw
    $camera.draw_background
    $smoke.draw
    $camera.draw_characters
    $explosion.draw
    #@quadtree_enemy.draw 0.2, 0, 0
    #@quadtree_energy.draw 0, 0, 0.2
    $gui.draw
  end

  def check_collisions
    # Player against enemies
    @quadtree_enemy.update(@enemy_list, $camera.box)
    @quadtree_enemy.hit(@player.box, false).each {|enemy|
      @player.loose_energy
      break
    }

    # Bullets against enemies
    @player.bullet_list.each {|bullet|
      @quadtree_enemy.hit(bullet.box).each {|enemy|
        add Energy.new(enemy.x, enemy.y, @player)
        bullet.explode
        remove enemy
        remove bullet
        break
      }
    }

    # Player against energy
    @quadtree_energy.update(@energy_list, $camera.box, 0, @player)
    @quadtree_energy.hit(@player.box, false).each {|energy|
      @player.gain_energy
      remove energy
    }
  end

  def check_map
    if not @map.is_discoverd @player.x, @player.y
      add @map.generate_enemies @player.x, @player.y
    end
  end

  def remove item
    case item.class.to_s
      when 'Array'
        item.each{|e| remove e}
      when 'Energy'
        $camera.remove_character item
        @energy_list.delete item
      when 'Enemy'
        $camera.remove_character item
        @enemy_list.delete item
      when 'Bullet'
        @player.bullet_list.delete item
    end
  end

  def add item
    case item.class.to_s
      when 'Array'
        item.each{|e| add e}
      when 'Energy'
        $camera.prepend_character item
        @energy_list += [item]
      when 'Enemy'
        $camera.append_character item
        @enemy_list += [item]
    end
  end

end


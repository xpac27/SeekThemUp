require 'rubygems'
require 'rubygame'
require 'game/rect'
require 'game/moveable'
require 'game/world'
require 'game/camera'
require 'game/cursor'
require 'game/smoke'
require 'game/moveable/player'
require 'game/moveable/enemy'
require 'game/moveable/bullet'
require 'game/moveable/puff'
require 'game/util/quadtree'
require 'game/util/tool'

require 'gl'
require 'glu'

include Gl
include Glu

include Rubygame
include Rubygame::Events


class Game

  include EventHandler::HasEventHandler

  def initialize
    @screen = Screen.new [800, 600], 0, [HWSURFACE, DOUBLEBUF, OPENGL]
    @screen.title = 'seekThemUp'

    $clock = Clock.new
    $clock.target_framerate = 60
    $clock.enable_tick_events
    $clock.calibrate

    @queue = EventQueue.new
    @queue.enable_new_style_events

    glClearColor 0.0, 0.0, 0.0, 0.0
    resize 800, 600

    @quadtree = Quadtree.new
    @world    = World.new
    @player   = Player.new

    $camera    = Camera.new
    $cursor    = Cursor.new

    @enemy_list = []
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
    $camera.add_character @player
    $camera.add_character @enemy_list

    @active_keys = []
    @running = true
  end

  def handle_events
    @queue.each do |event|
      case event
        when KeyPressed
          @active_keys.push event.key
        when KeyReleased
          @active_keys.delete event.key
        when MousePressed
          @player.shooting = true if event.button == :mouse_left
        when MouseReleased
          @player.shooting = false if event.button == :mouse_left
        when MouseMoved
          $cursor.x = event.pos[0]
          $cursor.y = event.pos[1]
      end
    end
  end

  def handle_keys
    @active_keys.each{|key|
      case key
        when :w          : @player.move_foreward
        when :s          : @player.move_backward
        when :a          : @player.move_left
        when :d          : @player.move_right
        when :f          : puts $clock.framerate
        when :q          : @running = false
        when :escape     : @running = false
      end
    }
  end

  def resize(w, h)
    h = 1 if h == 0
    glViewport 0, 0, w, h
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    gluPerspective 45.0, w.to_f / h.to_f, 1.0, 1000.0
    glMatrixMode GL_MODELVIEW
  end

  def go
    loop do
      break unless @running
      $clock.tick
      handle_events
      handle_keys
      update
      draw
    end
  end

  def update
    $camera.update
    @player.update
    @enemy_list.each{|item|
      item.update
    }

    colided = false
    @quadtree.update(@enemy_list, $camera.box, 0)
    @quadtree.hit(@player.box).each{|item|
      colided = true
    }
    $camera.shake 2 if colided

    @player.bullet_list.each{|bullet|
      @quadtree.hit(bullet.box).each{|item|
        $camera.remove_character item
        @enemy_list.delete item
        @player.bullet_list.delete bullet
        break
      }
    }
  end

  def draw
    glViewport 0, 0, 800, 600
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    glOrtho 0, 800, 600, 0, -1, 1
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    $camera.draw
    @quadtree.draw

    GL.swap_buffers
  end

end

Game.new.go
Rubygame.quit


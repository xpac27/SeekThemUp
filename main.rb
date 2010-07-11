require 'rubygems'
require 'rubygame'

require 'gl'
require 'glu'

require 'rubygame/sfont'

require 'game'
require 'game/gui'
require 'game/rect'
require 'game/text'
require 'game/moveable'
require 'game/world'
require 'game/camera'
require 'game/cursor'
require 'game/smoke'
require 'game/explosion'
require 'game/quadtree'
require 'game/moveable/player'
require 'game/moveable/enemy'
require 'game/moveable/bullet'
require 'game/moveable/puff'
require 'game/moveable/projectil'
require 'game/moveable/energy'


include Gl
include Glu

include Rubygame
include Rubygame::Events


class Main

  include EventHandler::HasEventHandler

  def initialize
    $screen    = Screen.new [800, 600], 0, [HWSURFACE, DOUBLEBUF, OPENGL]
    $text      = Text.new 'game/media/font/Arial_36_yellow_blackout_0.png'
    $gui       = Gui.new
    $clock     = Clock.new
    $cursor    = Cursor.new
    $camera    = Camera.new
    $smoke     = Smoke.new
    $explosion = Explosion.new

    $clock.target_framerate = 60
    $clock.enable_tick_events
    $clock.calibrate

    @active_keys = []
    @running     = true
    @queue       = EventQueue.new
    @queue.enable_new_style_events

    glClearColor 0.0, 0.0, 0.0, 1.0
    glEnable GL_BLEND
    glBlendFunc GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
    resize 800, 600

    @game = Game.new
  end

  def handle_events
    @queue.each do |event|
      case event
        when KeyPressed
          case event.key
            when :f      : puts $clock.framerate
            when :q      : @running = false
            when :escape : @running = false
          end
          @active_keys.push event.key
        when KeyReleased
          @active_keys.delete event.key
        when MousePressed
          @active_keys.push event.button
        when MouseReleased
          @active_keys.delete event.button
        when MouseMoved
          $cursor.x = event.pos[0]
          $cursor.y = event.pos[1]
      end
    end
  end

  def handle_keys
    @game.handle_keys @active_keys
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
      @game.update
  end

  def draw
    #ObjectSpace.garbage_collect

    glViewport 0, 0, 800, 600
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    glOrtho 0, 800, 600, 0, -1, 1
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    @game.draw

    GL.swap_buffers

    $screen.title = 'FPS: ' + $clock.framerate.to_i.to_s
  end

end

Main.new.go
Rubygame.quit


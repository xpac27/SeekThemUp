require 'rubygems'
require 'rubygame'

require 'gl'
require 'glu'

require 'game'
require 'game/rect'
require 'game/moveable'
require 'game/world'
require 'game/camera'
require 'game/cursor'
require 'game/smoke'
require 'game/quadtree'
require 'game/moveable/player'
require 'game/moveable/enemy'
require 'game/moveable/bullet'
require 'game/moveable/puff'


include Gl
include Glu

include Rubygame
include Rubygame::Events


class Main

  include EventHandler::HasEventHandler

  def initialize
    @screen = Screen.new [800, 600], 0, [HWSURFACE, DOUBLEBUF, OPENGL]
    @screen.title = 'seekThemUp'

    $clock = Clock.new
    $clock.target_framerate = 60
    $clock.enable_tick_events
    $clock.calibrate

    $cursor = Cursor.new

    glClearColor 0.0, 0.0, 0.0, 0.0
    resize 800, 600

    @queue = EventQueue.new
    @queue.enable_new_style_events

    @active_keys = []
    @running = true

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
    glViewport 0, 0, 800, 600
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    glOrtho 0, 800, 600, 0, -1, 1
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    @game.draw

    GL.swap_buffers
  end

end

Main.new.go
Rubygame.quit


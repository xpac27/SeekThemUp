require 'rubygems'
require 'rubygame'

require 'gl'
require 'glu'

include Gl
include Glu

include Rubygame
include Rubygame::Events


class Game

  def initialize
    @screen = Screen.new [800, 600], 0, [HWSURFACE, DOUBLEBUF, OPENGL]
    @screen.title = 'test'

    $clock = Clock.new
    $clock.target_framerate = 60
    $clock.enable_tick_events
    $clock.calibrate

    @queue = EventQueue.new
    @queue.enable_new_style_events

    glClearColor 0.0, 0.0, 0.0, 0.0
    resize 800, 600

    @active_keys = []
    @running = true

    @ball1_x = 400.0
    @ball1_y = 300.0

    @ball1_px = 300.0
    @ball1_py = 500.0

    @ball2_x = 500.0
    @ball2_y = 300.0

    @ball2_px = 600.0
    @ball2_py = 500.0
  end

  def handle_events
    @queue.each do |event|
      case event
        when KeyPressed
          @active_keys.push event.key
        when KeyReleased
          @active_keys.delete event.key
        when MousePressed
          @click = true
        when MouseReleased
          @click = false
          @ball1_clicked = false
          @ball2_clicked = false
          @click_locked = false
        when MouseMoved
          @mousex = event.pos[0]
          @mousey = event.pos[1]
      end
    end
  end

  def handle_keys
    @active_keys.each{|key|
      case key
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
      $clock.tick
      handle_events
      handle_keys
      update
      break unless @running
    end
  end

  def update
    glViewport 0, 0, 800, 600
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    glOrtho 0, 800, 600, 0, -1, 1
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glColor3f 1, 0, 0
    draw_point @ball1_x, @ball1_y
    #glColor3f 0.2, 0, 0
    #draw_big_point @ball1_px, @ball1_py
    glColor3f 0.5, 0, 0
    #draw_point @ball1_px, @ball1_py
    draw_line @ball1_x, @ball1_y, @ball1_px, @ball1_py

    glColor3f 0, 0, 1
    draw_point @ball2_x, @ball2_y
    glColor3f 0, 0, 0.5
    draw_point @ball2_px, @ball2_py
    draw_line @ball2_x, @ball2_y, @ball2_px, @ball2_py

    glColor3f 1, 1, 0
    draw_point @ball2_tx, @ball2_ty

    glColor3f 1, 1, 1
    draw_point @collision_x, @collision_y



    #######################
    # METHOD 1
    #######################

    pt0x = @ball1_x
    pt0y = @ball1_y
    pt1x = @ball1_px
    pt1y = @ball1_py
    pt2x = @ball2_x
    pt2y = @ball2_y
    pt3x = @ball2_px
    pt3y = @ball2_py

    s1x = pt1x - pt0x;
    s1y = pt1y - pt0y;
    s2x = pt3x - pt2x;
    s2y = pt3y - pt2y;

    s = (-s1y*(pt0x-pt2x) + s1x*(pt0y-pt2y)) / (-s2x*s1y + s1x*s2y);
    t = ( s2x*(pt0y-pt2y) - s2y*(pt0x-pt2x)) / (-s2x*s1y + s1x*s2y);

    @collision_x = pt0x + t*s1x
    @collision_y = pt0y + t*s1y

    @ball2_tx = pt2x + t*s2x
    @ball2_ty = pt2y + t*s2y


    #######################
    # METHOD 2
    #######################

    ok = false

    @direction = {
      :px => @ball2_px,
      :py => @ball2_py,
      :x  => @ball2_x - (@ball1_x - @ball1_px),
      :y  => @ball2_y - (@ball1_y - @ball1_py)
    }

    glColor3f 1, 1, 1
    draw_line @direction[:x], @direction[:y], @direction[:px], @direction[:py]

    left      = @ball1_px - 5 - 5
    right     = @ball1_px + 5 + 5
    top       = @ball1_py - 5 - 5
    bottom    = @ball1_py + 5 + 5
    [
      [left,  top,    right, top   ],
      [right, top,    right, bottom],
      [left,  bottom, left,  top   ],
      [right, bottom, left,  bottom],
    ].each{|p|
      glColor3f 0.6, 0.6, 0.6
      draw_line p[0], p[1], p[2], p[3]
      if (segments_colide? p[0], p[1], p[2], p[3], @direction[:x], @direction[:y], @direction[:px], @direction[:py])
        ok = true
        break
      end
    }

    if ok
      puts 'METHOD 2 OK'
    else
      puts 'METHOD 2 ...'
    end

    GL.swap_buffers

    #move_point1
    #move_point2
    check_mouse
  end

  def segments_colide? ax, ay, bx, by, cx, cy, dx, dy
      #puts ax.to_s + 'x' + ay.to_s + ' >> ' + bx.to_s + 'x' + by.to_s + ' || ' + cx.to_s + 'x' + cy.to_s + ' >> ' + dx.to_s + 'x' + dy.to_s
      return false if (ax == bx and ay == by)
      return false if (cx == dx and cy == dy)
      s1x = ax-bx;
      s1y = ay-by;
      s2x = cx-dx;
      s2y = cy-dy;
      s = (-s1y*(bx-dx) + s1x*(by-dy)) / (-s2x*s1y + s1x*s2y);
      t = ( s2x*(by-dy) - s2y*(bx-dx)) / (-s2x*s1y + s1x*s2y);
      return (s >= 0 and s <= 1 and t >= 0 and t <= 1)
  end

  def check_mouse
    if @ball1_clicked or (!@click_locked and @click and Math.sqrt((@ball1_x - @mousex)**2 + (@ball1_y - @mousey)**2) < 20)
      @ball1_x = @mousex
      @ball1_y = @mousey
      @ball1_clicked = true
      @click_locked = true
    end
    if @ball2_clicked or (!@click_locked and @click and Math.sqrt((@ball2_x - @mousex)**2 + (@ball2_y - @mousey)**2) < 20)
      @ball2_x = @mousex
      @ball2_y = @mousey
      @ball2_clicked = true
      @click_locked = true
    end
  end

  def move_point1
    @direction1 = rand(10) if rand(30) == 1
    s = 1

    case @direction1
      when 0 then @ball1_y += s
      when 1 then @ball1_y -= s; @ball1_x += 1
      when 2 then @ball1_x += s
      when 3 then @ball1_x += s; @ball1_y += s;
      when 4 then @ball1_y += s
      when 5 then @ball1_x -= s; @ball1_y += s;
      when 6 then @ball1_x -= s
      when 7 then @ball1_x -= s; @ball1_y -= s;
    end
  end

  def move_point2
    @direction2 = rand(10) if rand(30) == 1
    s = 0.5

    case @direction2
      when 0 then @ball2_y += s
      when 1 then @ball2_y -= s; @ball2_x += 1
      when 2 then @ball2_x += s
      when 3 then @ball2_x += s; @ball2_y += s;
      when 4 then @ball2_y += s
      when 5 then @ball2_x -= s; @ball2_y += s;
      when 6 then @ball2_x -= s
      when 7 then @ball2_x -= s; @ball2_y -= s;
    end
  end

  def draw_point x, y
    glPushMatrix
      glTranslatef x, y, 0

      glBegin GL_QUADS
        glVertex2i  5,  5
        glVertex2i -5,  5
        glVertex2i -5, -5
        glVertex2i  5, -5
      glEnd
    glPopMatrix
  end

  def draw_big_point x, y
    glPushMatrix
      glTranslatef x, y, 0

      glBegin GL_QUADS
        glVertex2i  10,  10
        glVertex2i -10,  10
        glVertex2i -10, -10
        glVertex2i  10, -10
      glEnd
    glPopMatrix
  end

  def draw_line x1, y1, x2, y2
    glBegin GL_LINES
      glVertex2i x1, y1
      glVertex2i x2, y2
    glEnd
  end

end

Game.new.go
Rubygame.quit


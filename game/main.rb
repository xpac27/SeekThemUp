#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'
require 'game/player'
require 'game/enemy'
require 'game/quadtree'
require 'game/rect'
require 'game/fps'
require 'game/debug'


class MyWindow < Gosu::Window

  def initialize
    super(640, 480, false)
    self.caption = 'seekThemUp'

    @fps = Fps.new(self, :periodic)
    @debug = Debug.new(self, ['quad', 'test', 'colision'])
    @player = Player.new(self)
    @enemyList = []
    10.times {
      @enemyList += [Enemy.new(self)]
    }
    @quadtree = Quadtree.new(self)
  end

  def update
    if button_down?(Gosu::Button::KbUp)
      @player.translate(0, -1)
    end
    if button_down?(Gosu::Button::KbDown)
      @player.translate(0, 1)
    end
    if button_down?(Gosu::Button::KbRight)
      @player.translate(1, 0)
    end
    if button_down?(Gosu::Button::KbLeft)
      @player.translate(-1, 0)
    end

    @debug.update

    @player.update

    @enemyList.each{|item|
      item.update
    }

    @quadtree.update(@enemyList + [@player], Rect.new(self, self.width/2, self.height/2, self.width, self.height))

    # check everie item against each other
    @quadtree.check_colision

#    # check player against enemies
#    @quadtree.hit(@player.box).each{|item|
#      Debug::count('colision')
#      item.overlaps = true
#      item.colide(@player.box)
#    }
#
#    # check enemies against each other
#    @enemyList.each{|enemy|
#      @quadtree.hit(enemy.box).each{|item|
#      Debug::count('colision')
#        item.overlaps = true
#        item.colide(enemy.box)
#      }
#    }
  end

  def draw
    @quadtree.draw
    @player.draw
    @enemyList.each{|item|
      item.draw
    }
    @fps.draw
    @debug.draw
  end

  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end

end

w = MyWindow.new
w.show


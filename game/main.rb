#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'
require 'game/rect'
require 'game/moveable'
require 'game/world'
require 'game/camera'
require 'game/moveable/player'
require 'game/moveable/enemy'
require 'game/util/quadtree'
require 'game/util/fps'
require 'game/util/debug'
require 'game/util/tool'


class MyWindow < Gosu::Window

  attr_reader :camera

  def initialize
    super(800, 600, false)

    self.caption = 'seekThemUp'

    @fps      = Fps.new(self, :periodic)
    @debug    = Debug.new(self, ['quad', 'test', 'colision', 'area checked'])
    @quadtree = Quadtree.new(self)

    @world     = World.new(self)
    @player    = Player.new(self, 0, 0, 16)
    @camera    = Camera.new(self, @player)
    @enemyList = []
    200.times {
      enemy              = Enemy.new(self, 100, 100, 8)
      enemy.speed        = (rand(100) / 100.0) + 0.1
      enemy.acceleration = (rand(100) / 100.0) * 0.1 + 0.07
      enemy.friction     = (rand(100) / 100.0) * 0.05 + 0.01
      enemy.player       = @player
      @enemyList += [enemy]
    }
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

    @camera.update
    @player.update
    @enemyList.each{|item|
      item.update
    }

    @quadtree.update(@enemyList, @camera.box, 0, @player)
    @quadtree.hit(@player.box).each{|item|
      Debug::count('colision')
      item.overlaps = true
    }
  end

  def draw
    @world.draw
    #@quadtree.draw
    @player.draw
    @enemyList.each{|item|
      item.draw
    }
    @fps.draw
    #@debug.draw
  end

  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end

end

w = MyWindow.new
w.show


#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'
require 'game/player'
require 'game/enemy'
require 'game/quadtree'


class MyWindow < Gosu::Window

  $quad_total = 0

  def initialize
    super(640, 480, false)
    self.caption = 'seekThemUp'

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

    $quad_total = 0

    @player.update
    @enemyList.each{|item|
      item.update
    }
    @quadtree.update(@enemyList)
  end

  def draw
    @quadtree.draw
    @player.draw
    @enemyList.each{|item|
      item.draw
    }
  end

  def button_down(id)
    if id == 12
      puts $quad_total
    elsif id == Gosu::Button::KbEscape
      close
    end
  end

end

w = MyWindow.new
w.show


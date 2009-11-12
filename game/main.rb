#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'
require 'game/player'
require 'game/enemy'
require 'game/quadtree'
require 'game/rect'


class MyWindow < Gosu::Window

  $total_quad = 0
  $total_test = 0
  $total_colision = 0

  def initialize
    super(640, 480, false)
    self.caption = 'seekThemUp'

    @text_quad = Gosu::Font.new(self, Gosu::default_font_name, 18)
    @text_test = Gosu::Font.new(self, Gosu::default_font_name, 18)
    @text_colision = Gosu::Font.new(self, Gosu::default_font_name, 18)

    @player = Player.new(self)
    @enemyList = []
    3.times {
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

    $total_quad = 0
    $total_test = 0
    $total_colision = 0

    @player.update
    @enemyList.each{|item|
      item.update
    }
    @quadtree.update(@enemyList)
    @quadtree.hit(@player.box).each{|item|
      $total_colision += 1
      item.overlaps = true
    }
  end

  def draw
    @quadtree.draw
    @player.draw
    @enemyList.each{|item|
      item.draw
    }

    @text_quad.draw('quad: ' + $total_quad.to_s, 10, 10, 9, 1.0, 1.0, 0xFFFFFFFF)
    @text_test.draw('test: ' + $total_test.to_s, 10, 30, 9, 1.0, 1.0, 0xFFFFFFFF)
    @text_colision.draw('colision: ' + $total_colision.to_s, 10, 50, 9, 1.0, 1.0, 0xFFFFFFFF)
  end

  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end

end

w = MyWindow.new
w.show


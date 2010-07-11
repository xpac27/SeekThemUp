class Camera

  attr_reader :x, :y, :box

  def initialize
    @x = 0
    @y = 0
    @characters = []
    @backgrounds = []
    @box = Rect.new @x, @y, 800, 600
  end

  def update
    if @x - @subject.x > 100
      @x -= (@x - (@subject.x + 100)) / 8
    elsif @x - @subject.x < -100
      @x -= (@x - (@subject.x - 100)) / 8
    end

    if @y - @subject.y > 100
      @y -= (@y - (@subject.y + 100)) / 8
    elsif @y - @subject.y < -100
      @y -= (@y - (@subject.y - 100)) / 8
    end

    @box.x = @x
    @box.y = @y
  end

  def draw_background
    @backgrounds.each{|item| item.draw_from self}
  end

  def draw_characters
    @characters.each {|item|
      draw_this item
    }
  end

  def draw_this item
    return unless is_visible? item
    glPushMatrix
      glTranslatef (-@x + 400), (-@y + 300), 0
      item.draw
    glPopMatrix
  end

  def set_subject item
    @subject = item
  end

  def add_background item
    @backgrounds << item
  end

  def append_character item
    if item.kind_of?(Array) then
      item.each{|c| append_character c}
    elsif
      @characters += [item]
    end
  end

  def prepend_character item
    if item.kind_of?(Array) then
      item.each{|c| prepend_character c}
    elsif
      @characters.unshift item
    end
  end

  def remove_character item
    @characters.delete item
  end

  def shake power
    @x = @x + (rand(3) - 1) * power
    @y = @y + (rand(3) - 1) * power
  end

  def is_visible? item
    item.box.touch? @box
  end

  def is_fully_visible? item
    item.box.overlaps? @box
  end

end


class Camera

	attr_reader :box, :x, :y

  def initialize(window, subject)
    @window  = window
    @subject = subject
    @x       = @subject.x
    @y       = @subject.y
    @box     = Rect.new(@window, @x, @y, @window.width, @window.height)
	end

  def update
		@x -= (@x - @subject.x) / 18.0
		@y -= (@y - @subject.y) / 18.0

    @box.x = @x
    @box.y = @y
	end

	def x
		@x - @window.width/2
	end

	def y
		@y - @window.height/2
	end

	def translate(x, y)
		@box.x += x
		@box.y += y
	end

end

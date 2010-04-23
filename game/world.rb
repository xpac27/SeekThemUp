class World

	def initialize(window)
    @window = window
	end

	def draw
		nx = (@window.camera.x/32).floor * 32
		ny = (@window.camera.y/32).floor * 32

		(@window.height/32 + 1).times{|n|
      @window.draw_line(\
				0 - @window.camera.x + nx, 32*n - @window.camera.y + ny, 0xFF222222, \
				@window.width + 32 - @window.camera.x + nx, 32*n - @window.camera.y + ny, 0xFF222222 \
			)
		}
		(@window.width/32 + 1).times{|n|
      @window.draw_line(\
				32*n - @window.camera.x + nx, 0 - @window.camera.y + ny, 0xFF222222, \
				32*n - @window.camera.x + nx, @window.height + 32 - @window.camera.y + ny, 0xFF222222 \
			)
		}
	end

end


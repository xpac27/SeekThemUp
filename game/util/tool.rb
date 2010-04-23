module Tool

	def self.distance(item1, item2)
		return Math.sqrt((item1.x - item2.x)**2 + (item1.y - item2.y)**2)
	end

end


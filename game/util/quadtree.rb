class Quadtree

  def initialize(window)
    @window = window
    @is_leaf = true
    @itemList = []
  end

  def update(items, area=nil, depth=0, focus=nil)
    Debug::count('quad')

    @depth = depth
    @itemList = []

    if area
      @area = area
    else
      @area = items[0].box.dup
      items.each {|item| @area.union!(item.box)}
    end

    if items.length > 1 and @depth <= 3
      @is_leaf = false

      # make the list of north/west, north/est, sud/est, sud/west items
      nw_items = []
      ne_items = []
      se_items = []
      sw_items = []
      items.each do |item|
        # Which of the sub-quadrants does the item overlap?
        in_nw = (item.box.left <= @area.x and item.box.top <= @area.y)
        in_ne = (item.box.right >= @area.x and item.box.top <= @area.y)
        in_se = (item.box.right >= @area.x and item.box.bottom >= @area.y)
        in_sw = (item.box.left <= @area.x and item.box.bottom >= @area.y)

        nw_items += [item] if in_nw
        ne_items += [item] if in_ne
        se_items += [item] if in_se
        sw_items += [item] if in_sw
      end

      # Create the sub-quadrants
      @nw_quad = Quadtree.new(@window)
      @ne_quad = Quadtree.new(@window)
      @se_quad = Quadtree.new(@window)
      @sw_quad = Quadtree.new(@window)

      # fill them with their items if they have some
			if (focus)
				@nw_quad.update(nw_items, @area.nw_quadrant, @depth + 1, focus) if (nw_items.length != 0 and (focus.box.left <= @area.x and focus.box.top <= @area.y))
				@ne_quad.update(ne_items, @area.ne_quadrant, @depth + 1, focus) if (ne_items.length != 0 and (focus.box.right >= @area.x and focus.box.top <= @area.y))
				@se_quad.update(se_items, @area.se_quadrant, @depth + 1, focus) if (se_items.length != 0 and (focus.box.right >= @area.x and focus.box.bottom >= @area.y))
				@sw_quad.update(sw_items, @area.sw_quadrant, @depth + 1, focus) if (sw_items.length != 0 and (focus.box.left <= @area.x and focus.box.bottom >= @area.y))
			else
				@nw_quad.update(nw_items, @area.nw_quadrant, @depth + 1) if nw_items.length != 0
				@ne_quad.update(ne_items, @area.ne_quadrant, @depth + 1) if ne_items.length != 0
				@se_quad.update(se_items, @area.se_quadrant, @depth + 1) if se_items.length != 0
				@sw_quad.update(sw_items, @area.sw_quadrant, @depth + 1) if sw_items.length != 0
			end
    else
      @itemList = items
      @is_leaf = true
    end
  end

  def draw
#    @area.outline(0xFFAAFFAA) if @depth == 0

    unless @is_leaf
      @window.draw_line(@area.x, @area.top, 0xFF003300, @area.x, @area.bottom, 0xFF003300, 7)
      @window.draw_line(@area.left, @area.y, 0xFF003300, @area.right, @area.y, 0xFF003300, 7)

      @nw_quad.draw
      @ne_quad.draw
      @se_quad.draw
      @sw_quad.draw
    end
  end

  def hit(rect)
    # grab all items at this level that overlaps the rect
    hits = @itemList.select{|item| (item.box != rect and item.box.overlaps?(rect))}

    unless @is_leaf
      # recursively check for lower quadrans
      hits += @nw_quad.hit(rect) if (rect.left <= @area.x and rect.top <= @area.y)
      hits += @sw_quad.hit(rect) if (rect.left <= @area.x and rect.bottom >= @area.y)
      hits += @ne_quad.hit(rect) if (rect.right >= @area.x and rect.top <= @area.y)
      hits += @se_quad.hit(rect) if (rect.right >= @area.x and rect.bottom >= @area.y)
    end

#    @area.draw(0x11FFFFFF) if @area
    Debug::count('area checked')

    hits
  end

  def check_colision
    @itemList.each_index{|i|
      @itemList[i + 1, @itemList.length].each{|item|
        if @itemList[i].box.overlaps?(item.box)
          Debug::count('colision')
          @itemList[i].overlaps = true
          item.overlaps = true
        end
      }
    }

#    @area.draw(0x11FFFFFF) if @area
    Debug::count('area checked')

    unless @is_leaf
      @nw_quad.check_colision
      @ne_quad.check_colision
      @se_quad.check_colision
      @sw_quad.check_colision
    end
  end

end


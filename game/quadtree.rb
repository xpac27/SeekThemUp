class Quadtree

  def initialize(window)
    @window = window
    @is_leaf = true
    @itemList = []
  end

  def update(items, area=nil)
    $total_quad += 1

    @itemList = []

    if area
      @area = area
    else
      @area = items[0].box.dup
      items.each {|item| @area.union!(item.box)}
    end

    if items.length > 1
      @is_leaf = false

      # make the list of north/west, north/est, sud/est, sud/west items
      nw_items = []
      ne_items = []
      se_items = []
      sw_items = []
      items.each do |item|
        # Which of the sub-quadrants does the item overlap?
        in_nw = item.box.left <= @area.x and item.box.top <= @area.y
        in_sw = item.box.left <= @area.x and item.box.bottom >= @area.y
        in_ne = item.box.right >= @area.x and item.box.top <= @area.y
        in_se = item.box.right >= @area.x and item.box.bottom >= @area.y

        # If it overlaps all 4 quadrants then insert it at the current deth
        if in_nw and in_ne and in_se and in_sw
            @itemList += [item]
        # otherwise append it to a list to be inserted under every quadrant that it overlaps
        else
            nw_items += [item] if in_nw
            ne_items += [item] if in_ne
            se_items += [item] if in_se
            sw_items += [item] if in_sw
        end
      end

      # Create the sub-quadrants
      @nw_quad = Quadtree.new(@window)
      @ne_quad = Quadtree.new(@window)
      @se_quad = Quadtree.new(@window)
      @sw_quad = Quadtree.new(@window)

      # fill them with their items if they have some
#      @nw_quad.update(nw_items, @area.nw_quadrant) if nw_items.length != 0
#      @ne_quad.update(ne_items, @area.ne_quadrant) if ne_items.length != 0
#      @se_quad.update(se_items, @area.se_quadrant) if se_items.length != 0
#      @sw_quad.update(sw_items, @area.sw_quadrant) if sw_items.length != 0
      @nw_quad.update(nw_items) if nw_items.length != 0
      @ne_quad.update(ne_items) if ne_items.length != 0
      @se_quad.update(se_items) if se_items.length != 0
      @sw_quad.update(sw_items) if sw_items.length != 0
    else
      @itemList = items
      @is_leaf = true
    end
  end

  def draw
    @area.outline(0xFFAAFFAA) if @area

    unless @is_leaf
      @window.draw_line(@area.x, @area.top, 0xFF003300, @area.x, @area.bottom, 0xFF003300, 9)
      @window.draw_line(@area.left, @area.y, 0xFF003300, @area.right, @area.y, 0xFF003300, 9)

      @nw_quad.draw
      @ne_quad.draw
      @se_quad.draw
      @sw_quad.draw
    end
  end

  def hit(rect)
    # grab all items at this level that overlaps the rect
    hits = @itemList.select{|item| item.box.overlaps?(rect)}

    unless @is_leaf
      # recursively check for lower quadrans
      hits += @nw_quad.hit(rect) if rect.left <= @area.x and rect.top <= @area.y
      hits += @sw_quad.hit(rect) if rect.left <= @area.x and rect.top >= @area.y
      hits += @ne_quad.hit(rect) if rect.left >= @area.x and rect.top <= @area.y
      hits += @se_quad.hit(rect) if rect.left >= @area.x and rect.top >= @area.y
    end

    hits
  end

end


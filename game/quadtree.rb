class Quadtree

  attr_reader :is_leaf

  def initialize(window)
    reset
    @window = window
    @top = 0
    @right = 0
    @bottom = 0
    @left = 0
    @center_x = 0
    @center_y = 0
  end

  def reset
    @itemList = []
    @is_leaf = true
  end

  def update(items)
    $total_quad += 1

    # compute top limit of this items rect
    @top = items[0].top
    items.each {|item| @top = item.top if item.top < @top}

    # compute left limit of this items rect
    @left = items[0].left
    items.each {|item| @left = item.left if item.left < @left}

    # compute bottom limit of this items rect
    @bottom = items[0].bottom
    items.each {|item| @bottom = item.bottom if item.bottom > @bottom}

    # compute right limit of this items rect
    @right = items[0].right
    items.each {|item| @right = item.right if item.right > @right}

    # compute the center of this rect
    @center_x = (@left + @right) / 2
    @center_y = (@top + @bottom) / 2

    if items.length == 1
      @itemList = items
      return
    end

    @is_leaf = false

    # make the list of north/west, north/est, sud/est, sud/west items
    nw_items = []
    ne_items = []
    se_items = []
    sw_items = []
    items.each do |item|
      # Which of the sub-quadrants does the item overlap?
      in_nw = item.left <= @center_x and item.top <= @center_y
      in_sw = item.left <= @center_x and item.bottom >= @center_y
      in_ne = item.right >= @center_x and item.top <= @center_y
      in_se = item.right >= @center_x and item.bottom >= @center_y

      # If it overlaps all 4 quadrants then insert it at the current
      # depth, otherwise append it to a list to be inserted under every
      # quadrant that it overlaps.
      if in_nw and in_ne and in_se and in_sw
          @itemList += [item]
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
    @nw_quad.update(nw_items) if nw_items.length != 0
    @ne_quad.update(ne_items) if ne_items.length != 0
    @se_quad.update(se_items) if se_items.length != 0
    @sw_quad.update(sw_items) if sw_items.length != 0
  end

  def draw
    @window.draw_line(@top, @left, 0xFFAAFFAA, @top, @right, 0xFFAAFFAA, 9)
    @window.draw_line(@bottom, @left, 0xFFAAFFAA, @bottom, @right, 0xFFAAFFAA, 9)
    @window.draw_line(@top, @left, 0xFFAAFFAA, @bottom, @left, 0xFFAAFFAA, 9)
    @window.draw_line(@top, @right, 0xFFAAFFAA, @bottom, @right, 0xFFAAFFAA, 9)

    unless @is_leaf
      @window.draw_line(@top, @center_x, 0xFF003300, @bottom, @center_x, 0xFF003300, 9)
      @window.draw_line(@center_y, @left, 0xFF003300, @center_y, @right, 0xFF003300, 9)

      @nw_quad.draw
      @ne_quad.draw
      @se_quad.draw
      @sw_quad.draw
    end
  end

  def overlaps?(rect, item)
    $total_test += 1
    rect.right >= item.left and rect.left <= item.right and rect.bottom >= item.top and rect.top <= item.bottom
  end

  def hit(rect)
    # grab all items at this level that overlaps the rect
    hits = @itemList.select{|item| overlaps?(rect, item)}

    unless @is_leaf
      # recursively check for lower quadrans
      hits += @nw_quad.hit(rect) if rect.left <= @center_x and rect.top <= @center_y
      hits += @sw_quad.hit(rect) if rect.left <= @center_x and rect.top >= @center_y
      hits += @ne_quad.hit(rect) if rect.left >= @center_x and rect.top <= @center_y
      hits += @se_quad.hit(rect) if rect.left >= @center_x and rect.top >= @center_y
    end

    hits
  end

end


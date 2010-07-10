class Gui

  def initialize
    @info = []
  end

  def set_info name, value
    @info.each_index{|i|
      if @info[i][0] == name
        @info[i][1] = value
        return
      end
    }
    @info << [name, value]
  end

  def draw
    @info.each_index{|i|
      $text.print 5, 5 + 16*i, (@info[i][0].to_s + ' ' + @info[i][1].to_s)
    }
  end

end


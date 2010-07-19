class Rectangle < Shape

  def initialize
    @gl_type = GL_QUADS

    # [[segment coordinates], [texture coordinates]]
    @segment_list = [
      [[ 1, -1], [1, 0]],
      [[ 1,  1], [1, 1]],
      [[-1,  1], [0, 1]],
      [[-1, -1], [0, 0]]
    ]
  end

end


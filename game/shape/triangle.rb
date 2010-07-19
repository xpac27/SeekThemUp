class Triangle < Shape

  def initialize
    @gl_type = GL_TRIANGLES

    # [[segment coordinates], [texture coordinates]]
    @segment_list = [
      [[-1, -1], [1, 0]],
      [[ 1,  0], [1, 1]],
      [[-1,  1], [0, 1]]
    ]
  end

end


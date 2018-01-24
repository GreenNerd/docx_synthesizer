module DocxSynthesizer
  class Filter::Dimension < Filter
    DEFAULT_WIDTH    = 2
    DEFAULT_HEIGHT   = 2
    DIMENSION_FACTOR = 72 * 12700

    attr_accessor :width, :height

    def initialize(str = '')
      parse_options(str.to_s)
    end

    private

    def parse_options(str)
      width, height = str.split('x'.freeze)

      @width  = (nonzero(width.to_f, DEFAULT_WIDTH)   * DIMENSION_FACTOR).to_i
      @height = (nonzero(height.to_f, DEFAULT_HEIGHT) * DIMENSION_FACTOR).to_i
    end

    def nonzero(float_number, default)
      float_number.zero? ? default : float_number
    end
  end

  Filter.register_filter(:dimension, Filter::Dimension)
end

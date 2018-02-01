module DocxSynthesizer
  class Filter::Dimension < Filter
    DIMENSION_FACTOR = 72 * 12700

    attr_accessor :width, :height

    def initialize(str = '')
      parse_options(str.to_s)
    end

    def dimension
      [width, height]
    end

    private

    def parse_options(str)
      width, height = str.split('x'.freeze)

      @width  = (nonzero(width.to_f, DocxSynthesizer.configuration.dimension_options.width)   * DIMENSION_FACTOR).to_i
      @height = (nonzero(height.to_f, DocxSynthesizer.configuration.dimension_options.height) * DIMENSION_FACTOR).to_i
    end

    def nonzero(float_number, default)
      float_number.zero? ? default : float_number
    end
  end

  Filter.register_filter(:dimension, Filter::Dimension)
end

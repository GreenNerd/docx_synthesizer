module DocxSynthesizer
  class Filter::BackgroundSize < Filter
    KEYWORDS = ['contain', 'cover'].freeze
    RATIO_FACTOR = 100 * 1000

    def initialize(str = KEYWORDS.first)
      @keyword =
        if KEYWORDS.include?(str)
          str
        else
          Configuration.background_size_options.default
        end
    end

    def crop(dimension, original_dimension)
      w1, h1 = dimension.map(&:to_f)
      w2, h2 = original_dimension.map(&:to_f)

      case w2/w1 <=> h2/h1
      when 1
        # +---+ +---------+
        # |   | |         |
        # +---+ +---------+
        if @keyword == 'cover'
          scaling = h1/h2
          width = w2 * scaling

          formatted = format_ratio(1 - w1 / width)

          [w1.to_i, h1.to_i, formatted, 0, formatted, 0]
        else
          scaling = w1/w2
          height = h2 * scaling

          formatted = format_ratio(1 - h1 / height)

          [w1.to_i, h1.to_i, 0, formatted, 0, formatted]
        end
      when -1
        #           +----+
        #           |    |
        # +-------+ |    |
        # |       | |    |
        # +-------+ +----+
        if @keyword == 'cover'
          scaling = w1/w2
          height = h2 * scaling

          formatted = format_ratio(1 - h1 / height)

          [w1.to_i, h1.to_i, 0, formatted, 0, formatted]
        else
          scaling = h1/h2
          width = w2 * scaling

          formatted = format_ratio(1 - w1 / width)

          [w1.to_i, h1.to_i, formatted, 0, formatted, 0]
        end
      else
        [w1.to_i, h1.to_i, 0, 0, 0, 0]
      end
    end

    private

    def format_ratio(ratio)
      (ratio / 2 * RATIO_FACTOR).to_i
    end
  end

  Filter.register_filter(:background_size, Filter::BackgroundSize)
end

module DocxSynthesizer
  class Configuration
    include Singleton

    DefaultTimeout = 2

    DefaultFetchOptions = {
      read_timeout: DefaultTimeout,
      open_timeout: DefaultTimeout,
      proxy: nil,
      http_header: {}
    }

    DefaultDimensionOptions = {
      width: 2,
      height: 2
    }

    DefaultBackgroundSizeOptions = {
      default: 'contain'
    }

    attr_reader :fetch_options, :dimension_options, :background_size_options, :threads_on

    def initialize
      @fetch_options = DefaultFetchOptions.dup
      @dimension_options = DefaultDimensionOptions.dup
      @background_size = DefaultBackgroundSizeOptions.dup
      @threads_on = true
    end

    def fetch_options=(options)
      @fetch_options = DefaultFetchOptions.merge(options)
    end

    def dimension_options=(options)
      @fetch_options = DefaultFetchOptions.merge(options)
    end

    def background_size_options=(options)
      @background_size_options = DefaultBackgroundSizeOptions.merge(options)
    end

    def threads_on=(boolean)
      @threads_on = boolean
    end
  end
end

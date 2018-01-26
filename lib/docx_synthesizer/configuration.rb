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

    attr_reader :fetch_options

    def initialize
      @fetch_options = DefaultFetchOptions.dup
    end

    def fetch_options=(options)
      @fetch_options = DefaultFetchOptions.merge(options)
    end
  end
end

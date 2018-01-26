module DocxSynthesizer
  module Helper
    module_function

    def compact_and_strip(array)
      array.delete_if(&:empty?)
      array.map(&:strip!)
      array
    end

    def broken_image_path
      File.expand_path('./assets/broken-image.png', File.dirname(__FILE__))
    end

    def setup_http
      begin
        @parsed_uri = URI.parse(uri)
      rescue URI::InvalidURIError
        fetch_using_file_open
      else
        if @parsed_uri.scheme == "http" || @parsed_uri.scheme == "https"
          fetch_using_http
        end
      end

      proxy = proxy_uri

      if proxy
        @http = Net::HTTP::Proxy(proxy.host, proxy.port).new(@parsed_uri.host, @parsed_uri.port)
      else
        @http = Net::HTTP.new(@parsed_uri.host, @parsed_uri.port)
      end
      @http.use_ssl = (@parsed_uri.scheme == "https")
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http.open_timeout = @options[:timeout]
      @http.read_timeout = @options[:timeout]


      http_header = {'Accept-Encoding' => 'identity'}.merge(@options[:http_header])

      setup_http
      @http.request_get(@parsed_uri.request_uri, http_header) do |res|
        if res.is_a?(Net::HTTPRedirection) && @redirect_count < 4
          @redirect_count += 1
          begin
            newly_parsed_uri = URI.parse(res['Location'])
            # The new location may be relative - check for that
            if protocol_relative_url?(res['Location'])
              @parsed_uri = URI.parse("#{@parsed_uri.scheme}:#{res['Location']}")
            elsif newly_parsed_uri.scheme != "http" && newly_parsed_uri.scheme != "https"
              @parsed_uri.path = res['Location']
            else
              @parsed_uri = newly_parsed_uri
            end
          rescue URI::InvalidURIError
          else
            fetch_using_http_from_parsed_uri
            break
          end
        end

        raise FetchFailure unless res.is_a?(Net::HTTPSuccess)
      end
    end

    def proxy_uri
      configuration = DocxSynthesizer.configuration

      begin
        if configuration.proxy
          URI.parse(configuration.proxy)
        else
          ENV['http_proxy'] && ENV['http_proxy'] != '' ? URI.parse(ENV['http_proxy']) : nil
        end
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end

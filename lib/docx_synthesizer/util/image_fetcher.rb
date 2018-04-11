module DocxSynthesizer
  module Util
    class ImageFetcher
      def initialize(uri)
        @uri = uri
      end

      def fetch
        begin
          @parsed_uri = URI.parse(@uri)
        rescue URI::InvalidURIError
          fetch_using_file_open
        else
          if @parsed_uri.scheme == 'http' || @parsed_uri.scheme == 'https'
            fetch_using_http
          else
            fetch_using_file_open
          end
        end
      rescue Timeout::Error, SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET, ImageFetchFailure, Net::HTTPBadResponse, EOFError, Errno::ENOENT
        open_broken_image
      end

      private

      def fetch_using_file_open
        File.open(@uri)
      end

      def open_broken_image
        File.open File.expand_path('../../assets/broken-image.png', __FILE__)
      end

      def fetch_using_http
        @redirect_count = 0

        fetch_using_http_from_parsed_uri
      end

      def fetch_using_http_from_parsed_uri
        http_header = { 'Accept-Encoding' => 'identity' }.merge(configuration[:http_header])

        setup_http

        @http.request_get(@parsed_uri.request_uri, http_header) do |res|
          if res.is_a?(Net::HTTPRedirection) && @redirect_count < 4
            @redirect_count += 1
            begin
              newly_parsed_uri = URI.parse(res['Location'])
              # The new location may be relative - check for that
              if protocol_relative_url?(res['Location'])
                @parsed_uri = URI.parse("#{@parsed_uri.scheme}:#{res['Location']}")
              elsif newly_parsed_uri.scheme != 'http' && newly_parsed_uri.scheme != 'https'
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

          raise ImageFetchFailure.new(@parsed_uri) unless res.is_a?(Net::HTTPSuccess)

          return StringIO.new(res.body)
        end
      end

      def setup_http
        proxy = proxy_uri

        if proxy
          @http = Net::HTTP::Proxy(proxy.host, proxy.port).new(@parsed_uri.host, @parsed_uri.port)
        else
          @http = Net::HTTP.new(@parsed_uri.host, @parsed_uri.port)
        end
        @http.use_ssl = (@parsed_uri.scheme == 'https')
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @http.open_timeout = configuration[:open_timeout]
        @http.read_timeout = configuration[:read_timeout]
      end

      def proxy_uri
        begin
          if configuration[:proxy]
            URI.parse(configuration[:proxy])
          else
            ENV['http_proxy'] && ENV['http_proxy'] != '' ? URI.parse(ENV['http_proxy']) : nil
          end
        rescue URI::InvalidURIError
          nil
        end
      end

      def configuration
        @configuration ||= DocxSynthesizer.configuration.fetch_options
      end
    end
  end
end

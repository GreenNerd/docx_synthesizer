module DocxSynthesizer
  class Template
    attr_reader :doc

    def initialize(path)
      @path = path
      @doc = File.open(@path) { |f| Nokogiri::XML(f) }
    end

    def inspect
      "<#{self.class} path: \"#{@path}\">"
    end
  end
end

module DocxSynthesizer
  class Variable::Image < Variable
    attr_reader :url

    def initialize(value, url:)
      super(value)
      @url = url
    end

    def process(node_template)
      super(node_template)
    end

    def template
    end
  end
end

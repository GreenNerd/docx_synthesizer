module DocxSynthesizer
  class Template
    VARIABLE_NODE_PATH = %{//w:t[contains(text(), "{{")][contains(text(), "}}")][regex(., "#{Variable::NAME_REGEX.source}")]}.freeze

    attr_reader :doc

    def initialize(path)
      @path = path
      @doc = File.open(@path) { |f| Nokogiri::XML(f) }
    end

    def inspect
      "<#{self.class} path: \"#{@path}\">"
    end

    def render(context = {})
      context = Context.new(context)

      doc.xpath(VARIABLE_NODE_PATH, custom_regex_function).each do |node|
        Fragment.new(template, node).render(context)
      end
    end

    private

    def custom_regex_function
      @custom_regex_function ||= Class.new {
        def regex(node_set, regex_str)
          node_set.find_all { |node| node.text =~ /#{regex_str}/ }
        end
      }.new
    end
  end
end

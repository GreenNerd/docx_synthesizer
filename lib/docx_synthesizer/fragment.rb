module DocxSynthesizer
  class Fragment
    DEFAULT_SPACER = "、".freeze
    attr_reader :context

    def initialize(env)
      @env = env
      @context = env.context
    end

    def render(node)
      @wt_template = node.dup.tap { |obj| obj.content = nil }

      nodes = render_str(node.text)
      node_set = Nokogiri::XML::NodeSet.new(node.document, nodes.flatten.compact)
      node.replace(node_set)
    end

    def render_str(str)
      head, match, tail = str.partition(Variable::NAME_REGEX)

      if match.empty?
        [wrap_wt(str)]
      else
        [wrap_wt(head), evaluate(match), render_str(tail)]
      end
    end

    private

    def wrap_wt(text)
      return if text.empty?

      @wt_template.dup.tap { |obj| obj.content = text }
    end

    def evaluate(str)
      md = str.match(Variable::NAME_REGEX_WITH_CAPTURES)

      if variable = context[md[:variable_name]]
        variable.process(@wt_template, @env)
      else
        wrap_wt(str)
      end
    end
  end
end

module DocxSynthesizer
  class Fragment
    DEFAULT_SPACER = "、"
    attr_reader :context

    def initialize(env)
      @env = env
      @context = env.context
    end

    def render(node)
      @wt_template = node.dup.tap { |obj| obj.content = nil }

      wr_node = node.parent

      wr_template = node.parent.dup(0)

      if wrpr_node = node.parent.xpath('w:rPr').first
        wr_template.add_child(wrpr_node.dup)
      end

      current_node = wr_node

      render_presenter(node.text).flatten.each do |node_presenter|
        next unless node_presenter

        current_node = node_presenter.present(current_node, @wt_template, @env, wrpr_node: wrpr_node, wr_template: wr_template)
      end

      wr_node.remove
    end

    def render_presenter(str)
      head, match, tail = str.partition(Variable::NAME_REGEX)

      if match.empty?
        [wrap_wt(str)]
      else
        [wrap_wt(head), evaluate(match), render_presenter(tail)]
      end
    end

    private

    def wrap_wt(text)
      return if text.empty?

      DocxSynthesizer::Variable::Text.new(text).stash
    end

    def evaluate(str)
      md = str.match(Variable::NAME_REGEX_WITH_CAPTURES)

      if variable = context.lookup(md[:variable_name])
        variable.stash(Filter.parse(md[:filter_markup]))
      else
        wrap_wt(str)
      end
    end
  end
end

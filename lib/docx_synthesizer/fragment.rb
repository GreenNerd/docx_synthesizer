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

      render_str(node.text).flatten.each do |new_node|
        next unless new_node

        case new_node.name
        when 'hyperlink'
          if wrpr_node
            new_node.xpath('w:r/w:rPr').first.replace(wrpr_node.dup)
          end

          next_sibling = new_node
        when 'r'
          next_sibling = new_node
        else
          new_node['xml:space'] = 'preserve'
          next_sibling = wr_template.dup
          next_sibling.add_child(new_node)
        end

        current_node.add_next_sibling(next_sibling)
        current_node = next_sibling
      end

      wr_node.remove
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

      if variable = context.lookup(md[:variable_name])
        filters = Filter.parse(md[:filter_markup])

        variable.process(@wt_template, @env, filters)
      else
        wrap_wt(str)
      end
    end
  end
end

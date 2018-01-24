module DocxSynthesizer
  module Processor
    class Document
      VARIABLE_START = /\{\{/
      VARIABLE_END   = /\}\}/
      VARIABLE_INCOMPLETE_START_OR_END = /\{|\}/

      def process(doc, env)
        render_variables(doc, env)
      end

      private

      def render_variables(doc, env)
        fragment = Fragment.new(env)

        doc.xpath("//w:t[contains(text(), '{{')]").each do |node|
          collapse_node(node)
          if node.text =~ Variable::NAME_REGEX
            fragment.render(node)
          end
        end

        doc
      end

      private

      def collapse_node(node)
        will_collapsed_nodes = []

        wr_node = node.parent.next_sibling
        found = false

        while wr_node && !found
          will_collapsed_nodes.push wr_node

          case wr_node.text
          when VARIABLE_END
            found = true
          when VARIABLE_INCOMPLETE_START_OR_END
            wr_node = nil
          else
            wr_node = wr_node.next_sibling
          end
        end

        if found && will_collapsed_nodes.any?
          node.content = "#{node.text}#{will_collapsed_nodes.each(&:remove).map(&:text).join}"
        end
      end
    end
  end
end

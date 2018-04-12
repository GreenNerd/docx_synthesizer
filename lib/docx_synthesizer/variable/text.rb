module DocxSynthesizer
  class Variable::Text < Variable
    Presenter = Struct.new(:variable, :filters) do
      def present(current_node, node_template, env, options = {})
        new_node = variable.process(node_template, env, filters)

        next_sibling = options[:wr_template].dup
        next_sibling.add_child(new_node)

        current_node.add_next_sibling(next_sibling)
        next_sibling
      end
    end

    def process(node_template, env, filters = [], opts = {})
      super.tap { |node| node["xml:space"] = 'preserve'.freeze }
    end
  end
end

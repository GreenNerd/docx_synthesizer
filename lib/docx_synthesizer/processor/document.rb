module DocxSynthesizer
  module Processor
    class Document
      VARIABLE_NODE_PATH = %{//w:t[contains(text(), "{{")][contains(text(), "}}")][regex(., "#{Variable::NAME_REGEX.source}")]}.freeze

      def process(doc, env)
        render_variables(doc, env)
      end

      private

      def render_variables(doc, env)
        fragment = Fragment.new(env)

        doc.xpath(VARIABLE_NODE_PATH, custom_regex_function).each do |node|
          fragment.render(node)
        end

        doc
      end

      def custom_regex_function
        @custom_regex_function ||= Class.new {
          def regex(node_set, regex_str)
            node_set.find_all { |node| node.text =~ /#{regex_str}/ }
          end
        }.new
      end
    end
  end
end

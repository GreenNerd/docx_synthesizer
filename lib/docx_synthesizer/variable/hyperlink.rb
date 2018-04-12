module DocxSynthesizer
  class Variable::Hyperlink < Variable
    class Presenter < Variable::Presenter
      def present(current_node, node_template, env, options = {})
        new_node = variable.process(node_template, env, filters)

        current_node.add_next_sibling(new_node)

        if options[:wrpr_node]
          current_wrpr_node = new_node.xpath('w:rPr').first

          if current_wrpr_node
            current_wrpr_node.replace(options[:wrpr_node].dup)
          end
        end

        new_node
      end
    end

    def initialize(value, url:)
      super(value)
      @url = url
    end

    def process(node_template, env, filters = [], opts = {})
      rid = env.add_hyperlink(@url)
      Nokogiri::XML.fragment(template % { rid: rid, url_text: value }).elements.first
    end

    private

    def template
      <<-TEMPLATE.gsub(/\n\s*/, '')
        <w:hyperlink r:id="%{rid}">
          <w:rPr>
            <w:rStyle w:val="Hyperlink"/>
          </w:rPr>
          <w:r>
            <w:t>%{url_text}</w:t>
          </w:r>
        </w:hyperlink>
      TEMPLATE
    end
  end
end

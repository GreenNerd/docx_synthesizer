module DocxSynthesizer
  module Processor
    class Styles
      def process(doc, env)
        styles_node = doc.at_xpath('w:styles')

        env.styles.new_styles.each do |style_id, style_node|
          styles_node.add_child style_node
          style_node['w:styleId'] = style_id
        end

        doc
      end
    end
  end
end

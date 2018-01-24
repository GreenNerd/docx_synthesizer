module DocxSynthesizer
  module Processor
    class Relationships
      def process(doc, env)
        relationships_node = doc.at_xpath('r:Relationships', r: DocxSynthesizer::Relationships::RELATIONSHIPS_NS_URI)

        env.relationships.new_rels.each do |attr_hash|
          node_attr = attr_hash.map { |k, v| format('%s="%s"', k, v) }.join(' ')
          relationships_node.add_child("<Relationship #{node_attr} />")
        end

        doc
      end
    end
  end
end

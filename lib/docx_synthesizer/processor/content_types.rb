# frozen_string_literal: true

module DocxSynthesizer
  module Processor
    class ContentTypes
      TYPES = {
        images: {
          png: 'image/png',
          jpg: 'image/jpeg',
          jpeg: 'image/jpeg',
          gif: 'image/gif',
          bmp: 'image/bmp'
        }.freeze
      }.freeze

      def process(doc, env)
        extensions = Set.new(doc.root.children.map { |child| child['Extension'] }.compact)

        TYPES[:images].each do |extension, content_type|
          next if extensions.include?(extension.to_s)
          extensions.add extension

          node = Nokogiri::XML::Node.new('Default', doc)
          node['Extension'] = extension
          node['ContentType'] = content_type
          doc.root << node
        end

        doc
      end
    end
  end
end

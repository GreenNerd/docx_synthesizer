module DocxSynthesizer
  class ContentType
    TYPES = {
      png: 'image/png',
      jpg: 'image/jpeg',
      jpeg: 'image/jpeg',
      gif: 'image/gif',
      bmp: 'image/bmp'
    }.freeze

    def self.render(str)
      xml_doc = Nokogiri::XML(str)

      TYPES.each do |extension, content_type|
        next if extensions(xml_doc).include?(extension.to_s)
        node = Nokogiri::XML::Node.new('Default', xml_doc)
        node['Extension'] = extension
        node['ContentType'] = content_type
        xml_doc.root << node
      end

      xml_doc
    end

    def self.extensions(doc)
      doc.root.children.map { |child| child['Extension'] }.compact.uniq
    end
  end
end

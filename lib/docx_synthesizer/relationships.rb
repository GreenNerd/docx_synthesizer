module DocxSynthesizer
  class Relationships
    BASE_URL = 'http://schemas.openxmlformats.org'.freeze
    YEAR = '2006'.freeze
    PICTURE_NS_URI = "#{BASE_URL}/drawingml/#{YEAR}/picture".freeze
    MAIN_NS_URI = "#{BASE_URL}/drawingml/#{YEAR}/main".freeze
    RELATIONSHIPS_NS_URI = "#{BASE_URL}/package/#{YEAR}/relationships".freeze
    IMAGE_TYPE = "#{BASE_URL}/officeDocument/#{YEAR}/relationships/image".freeze

    def initialize(zip_content)
      @new_rels = []
      @xml_doc = Nokogiri::XML(zip_content)
      @max_rid = initial_file_rid(@xml_doc)
    end

    def add_image(target)
      rid = "rId#{next_rid}"

      @new_rels.push(
        'Id' => rid,
        'Type' => IMAGE_TYPE,
        'Target' => target
      )

      rid
    end

    def render
      relationships = @xml_doc.at_xpath('r:Relationships', r: RELATIONSHIPS_NS_URI)

      @new_rels.each do |attr_hash|
        node_attr = attr_hash.map { |k, v| format('%s="%s"', k, v) }.join(' ')
        relationships.add_child("<Relationship #{node_attr} />")
      end

      @xml_doc
    end

    private

    def next_rid
      @max_rid += 1
    end

    def initial_file_rid(xml_node)
      xml_node.xpath('r:Relationships/r:Relationship', 'r' => RELATIONSHIPS_NS_URI).inject(0) do |max ,n|
        id = n.attributes['Id'].to_s[3..-1].to_i
        [id, max].max
      end
    end
  end
end

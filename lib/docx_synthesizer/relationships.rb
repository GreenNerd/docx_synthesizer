module DocxSynthesizer
  class Relationships
    BASE_URL = 'http://schemas.openxmlformats.org'.freeze
    YEAR = '2006'.freeze
    PICTURE_NS_URI = "#{BASE_URL}/drawingml/#{YEAR}/picture".freeze
    MAIN_NS_URI = "#{BASE_URL}/drawingml/#{YEAR}/main".freeze
    RELATIONSHIPS_NS_URI = "#{BASE_URL}/package/#{YEAR}/relationships".freeze
    IMAGE_TYPE = "#{BASE_URL}/officeDocument/#{YEAR}/relationships/image".freeze
    HYPERLINK_TYPE = "#{BASE_URL}/officeDocument/#{YEAR}/relationships/hyperlink".freeze

    attr_accessor :new_rels

    def initialize(zip_content)
      @new_rels = []
      @max_rid = initial_file_rid(Nokogiri::XML(zip_content))
    end

    def add_image(target)
      rid = "rId#{next_rid}"

      new_rels.push(
        'Id' => rid,
        'Type' => IMAGE_TYPE,
        'Target' => target
      )

      rid
    end

    def add_hyperlink(target)
      rid = "rId#{next_rid}"

      new_rels.push(
        'Id' => rid,
        'Type' => HYPERLINK_TYPE,
        'Target' => target,
        'TargetMode' => "External"
      )

      rid
    end

    private

    def next_rid
      @max_rid += 1
    end

    def initial_file_rid(xml_doc)
      xml_doc.xpath('r:Relationships/r:Relationship', 'r' => RELATIONSHIPS_NS_URI).inject(0) do |max ,n|
        id = n.attributes['Id'].to_s[3..-1].to_i
        [id, max].max
      end
    end
  end
end

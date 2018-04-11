require 'open-uri'
require 'securerandom'
require 'fastimage'

module DocxSynthesizer
  class Variable::Image < Variable
    attr_accessor :original_dimension

    def initialize(value, url:)
      super(value)
      @url = url

      @loaded = false
    end

    def process(node_template, env, filters = [], opts = {})
      fetch_image unless @loaded

      rid = env.add_image(@entry_name, @image_data)
      dimension_filter , background_size_filter = get_filters(filters)

      cx, cy, offset_l, offset_t, offset_r, offset_b = background_size_filter.crop(dimension_filter.dimension, original_dimension)

      options = {
        rid: rid,
        id: rid[/\d+/],
        image_name: value,
        cx: cx,
        cy: cy,
        offset_l: offset_l,
        offset_t: offset_t,
        offset_r: offset_r,
        offset_b: offset_b
      }
      Nokogiri::XML.fragment(template % options).elements.first
    end

    def self.allowed_filter_types
      @allowed_filter_types ||= Filter.filters.values_at(:dimension, :background_size)
    end

    def fetch_image
      stream = Util::ImageFetcher.new(@url).fetch

      fast_image = FastImage.new(stream)
      @original_dimension = fast_image.size
      @image_data = stream.read
      @entry_name = "media/#{SecureRandom.uuid}.#{fast_image.type}"

      @loaded = true
    end

    private

    def get_filters(filters)
      filters = Variable::Image.avaiable_filters(filters)
      [
        filters.find { |f| f.is_a?(Filter::Dimension) } || Filter::Dimension.new,
        filters.find { |f| f.is_a?(Filter::BackgroundSize) } || Filter::BackgroundSize.new
      ]
    end

    def template
      <<-TEMPLATE.gsub(/\n\s*/, '')
        <w:r>
          <w:rPr>
            <w:noProof />
          </w:rPr>
          <w:drawing>
            <wp:inline distT="0" distB="0" distL="0" distR="0">
              <wp:extent cx="%{cx}" cy="%{cy}" />
              <wp:docPr id="%{id}" name="%{image_name}" />
              <wp:cNvGraphicFramePr>
                <a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" noChangeAspect="1" />
              </wp:cNvGraphicFramePr>
              <a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
                <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
                  <pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
                    <pic:nvPicPr>
                      <pic:cNvPr id="%{id}" name="%{image_name}" />
                      <pic:cNvPicPr />
                    </pic:nvPicPr>
                    <pic:blipFill rotWithShape="1">
                      <a:blip r:embed="%{rid}">
                        <a:extLst>
                          <a:ext uri="{28A0092B-C50C-407E-A947-70E740481C1C}">
                            <a14:useLocalDpi xmlns:a14="http://schemas.microsoft.com/office/drawing/2010/main" val="0" />
                          </a:ext>
                        </a:extLst>
                      </a:blip>
                      <a:srcRect l="%{offset_l}" t="%{offset_t}" r="%{offset_r}" b="%{offset_b}" />
                      <a:stretch />
                    </pic:blipFill>
                    <pic:spPr bwMode="auto">
                      <a:xfrm>
                        <a:off x="0" y="0" />
                        <a:ext cx="%{cx}" cy="%{cy}" />
                      </a:xfrm>
                      <a:prstGeom prst="rect">
                        <a:avLst />
                      </a:prstGeom>
                      <a:ln>
                        <a:noFill />
                      </a:ln>
                      <a:extLst>
                        <a:ext uri="{53640926-AAD7-44D8-BBD7-CCE9431645EC}">
                          <a14:shadowObscured xmlns:a14="http://schemas.microsoft.com/office/drawing/2010/main" />
                        </a:ext>
                      </a:extLst>
                    </pic:spPr>
                  </pic:pic>
                </a:graphicData>
              </a:graphic>
            </wp:inline>
          </w:drawing>
        </w:r>
      TEMPLATE
    end
  end
end

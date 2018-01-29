module DocxSynthesizer
  class Variable::Hyperlink < Variable
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

module DocxSynthesizer
  module Helper
    module_function

    def compact_and_strip(array)
      array.delete_if(&:empty?)
      array.map(&:strip!)
      array
    end

    def safe(text)
      text.to_s
        .gsub('&', '&amp;')
        .gsub('>', '&gt;')
        .gsub('<', '&lt;')
    end
  end
end

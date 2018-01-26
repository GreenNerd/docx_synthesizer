module DocxSynthesizer
  module Helper
    module_function

    def compact_and_strip(array)
      array.delete_if(&:empty?)
      array.map(&:strip!)
      array
    end
  end
end

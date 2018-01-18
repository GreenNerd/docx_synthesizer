module DocxSynthesizer
  class Variable
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end

require 'docx_synthesizer/variable/text'
require 'docx_synthesizer/variable/file'
require 'docx_synthesizer/variable/image'

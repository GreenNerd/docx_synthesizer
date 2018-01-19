module DocxSynthesizer
  class Variable
    NAME_REGEX = /{{[\w]+}}/
    NAME_REGEX_WITH_CAPTURES = /{{(?<variable_name>[\w]+)}}/

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def process(node_template)
      node_template.dup.tap { |obj| obj.content = value}
    end
  end
end

require 'docx_synthesizer/variable/text'
require 'docx_synthesizer/variable/file'
require 'docx_synthesizer/variable/image'

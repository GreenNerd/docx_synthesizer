module DocxSynthesizer
  class Variable
    NAME_REGEX = /{{\s*[\w_]+\s*}}/
    NAME_REGEX_WITH_ANCHOR = /{{\s*(?<variable_name>[\w_]+)\s*}}/

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

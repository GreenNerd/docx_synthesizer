module DocxSynthesizer
  class Variable
    NAME_FRAGEMENT = /[\w\.]+/
    FILTER_SEPERATOR = /\|/
    FILTER_FRAGEMENT = /#{FILTER_SEPERATOR}[^|]+/
    FilterArgumentSeparator = /:/
    NAME_REGEX = /{{\s*#{NAME_FRAGEMENT}\s*(#{FILTER_FRAGEMENT})*\s*}}/
    NAME_REGEX_WITH_CAPTURES = /{{\s*(?<variable_name>#{NAME_FRAGEMENT})\s*(?<filter_markup>#{FILTER_FRAGEMENT}*)\s*}}/
    # {{ name | dimension:4x4 | background_size:cover }}

    Presenter = Struct.new(:variable, :filters) do
      def present(current_node, node_template, env, options = {})
        new_node = variable.process(node_template, env, filters)

        current_node.add_next_sibling(new_node)
        new_node
      end
    end

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def stash(filters = [])
      self.class::Presenter.new(self, filters)
    end

    def process(node_template, env, filters = [], opts = {})
      node_template.dup.tap { |obj| obj.content = value }
    end

    def self.avaiable_filters(filters)
      filters.reduce([]) do |memo, filter|
        if allowed_filter_types.include?(filter.class)
          memo.push filter
        end

        memo
      end
    end
  end
end

require 'docx_synthesizer/variable/text'
require 'docx_synthesizer/variable/hyperlink'
require 'docx_synthesizer/variable/image'
require 'docx_synthesizer/variable/array'

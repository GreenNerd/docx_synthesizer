module DocxSynthesizer
  class Filter
    class << self
      def parse(str)
        return [] unless str

        str.split(Variable::FILTER_SEPERATOR).reduce([]) do |memo, filter_markup|
          filter_name, options_str = filter_markup.split(Variable::FilterArgumentSeparator).map(&:strip)

          if filter = find_filter(filter_name)
            memo.push filter.new(options_str)
          end

          memo
        end
      end

      def register_filter(filter_name, filter_klass)
        filters[filter_name] = filter_klass
      end

      def find_filter(filter_name)
        return unless filter_name
        filters[filter_name.to_sym]
      end

      def filters
        @filters ||= {}
      end
    end
  end
end

require 'docx_synthesizer/filter/dimension'
require 'docx_synthesizer/filter/background_size'

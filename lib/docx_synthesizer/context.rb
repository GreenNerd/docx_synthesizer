require 'forwardable'

module DocxSynthesizer
  class Context
    extend Forwardable

    attr_reader :data
    def_delegators :@data, :[]

    def initialize(context)
      @image_variables = []
      @data = deep_transform(context)
      fetch_images if DocxSynthesizer.configuration.threads_on
    end

    def lookup(variable_name)

      @data.dig(*Util::Helper.compact_and_strip(variable_name.split('.')))
    end

    private

    def deep_transform(hash)
      Hash[hash.map { |k, v| transform_standard_key(k.to_s, v) }]
    end

    def transform_standard_key(key, value)
      [key, transform_value(value)]
    end

    def transform_value(value)
      case value
      when Hash
        deep_transform(value)
      when Array
        DocxSynthesizer::Variable::Array.new(value.map { |v| transform_value(v) })
      when DocxSynthesizer::Variable
        if DocxSynthesizer::Variable::Image === value
          @image_variables.push value
        end
        value
      else
        DocxSynthesizer::Variable::Text.new(value)
      end
    end

    def fetch_images
      @image_variables.map do |image_variable|
        Thread.new { image_variable.send :fetch_image }
      end.each(&:join)
    end
  end
end

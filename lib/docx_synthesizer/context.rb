require 'forwardable'

module DocxSynthesizer
  class Context
    extend Forwardable

    attr_reader :data
    def_delegators :@data, :[]

    def initialize(context)
      @data = deep_transform(context)
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
        value
      else
        DocxSynthesizer::Variable::Text.new(value)
      end
    end
  end
end

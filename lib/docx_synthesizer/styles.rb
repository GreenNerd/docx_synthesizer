require 'securerandom'

module DocxSynthesizer
  class Styles
    attr_accessor :new_styles

    def initialize(zip_content)
      @new_styles = {}
    end

    def add_style(style_node)
      style_id = SecureRandom.uuid

      new_styles[style_id] = style_node

      style_id
    end
  end
end

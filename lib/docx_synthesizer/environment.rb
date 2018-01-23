module DocxSynthesizer
  class Environment
    attr_reader :template
    attr_accessor :context, :relationships

    def initialize(template)
      @template = template
    end

    def add_image(target, image_data)
      rid = @relationships.add_image(target)

      template.zip_contents["word/#{target}"] = image_data

      rid
    end
  end
end

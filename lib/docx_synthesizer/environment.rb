module DocxSynthesizer
  class Environment
    attr_reader :template, :relationships
    attr_accessor :context

    def initialize(template, relationships)
      @template = template
      @relationships = relationships
    end

    def add_image(target, image_data)
      rid = @relationships.add_image(target)

      template.zip_contents["word/#{target}"] = image_data

      rid
    end
  end
end

module DocxSynthesizer
  class Environment
    attr_accessor :context, :relationships, :styles

    def initialize
      @media = {}
    end

    def add_image(target, image_data)
      rid = @relationships.add_image(target)

      stage_media("word/#{target}", image_data)

      rid
    end

    def add_hyperlink(target)
      @relationships.add_hyperlink(target)
    end

    def add_style(style_node)
      @styles.add_style(style_node)
    end

    def write_media(out)
      @media.each do |entry_name, media_data|
        out.put_next_entry(entry_name)
        out.write media_data
      end
    end

    private

    def stage_media(entry_name, media_data)
      @media[entry_name] = media_data
    end
  end
end

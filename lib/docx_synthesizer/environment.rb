module DocxSynthesizer
  class Environment
    attr_accessor :context, :relationships

    def initialize
      @media = {}
    end

    def add_image(target, image_data)
      rid = @relationships.add_image(target)

      stage_media("word/#{target}", image_data)

      rid
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

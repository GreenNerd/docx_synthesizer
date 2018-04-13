module DocxSynthesizer
  class EntryProcessors
    attr_accessor :to_be_processed, :processors

    def initialize(processors)
      @processors = processors
    end
  end

  class Processors
    def initialize(processors_hash)
      @processors = {}

      processors_hash.each do |entry_name, processor_klasses|
        next if processor_klasses.empty?

        @processors[entry_name] = EntryProcessors.new(processor_klasses.map(&:new))
      end
    end

    def process(out, env)
      @processors.each do |entry_name, entry_processor|
        entry_bytes = @processors[entry_name].to_be_processed
        next if entry_bytes.empty?

        xml_doc = Nokogiri::XML(entry_bytes)
        entry_processor.processors.each { |processor| processor.process(xml_doc, env) }
        out.put_next_entry(entry_name)
        out.write xml_doc.to_xml(indent: 0).gsub("\n".freeze, "".freeze)
      end
    end

    def stage(entry_name, entry_bytes)
      if @processors.key?(entry_name)
        @processors[entry_name].to_be_processed = entry_bytes
      end
    end
  end
end

require 'docx_synthesizer/processor/document'
require 'docx_synthesizer/processor/content_types'
require 'docx_synthesizer/processor/relationships'
require 'docx_synthesizer/processor/styles'

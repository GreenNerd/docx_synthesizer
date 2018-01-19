module DocxSynthesizer
  class Template
    VARIABLE_NODE_PATH = %{//w:t[contains(text(), "{{")][contains(text(), "}}")][regex(., "#{Variable::NAME_REGEX.source}")]}.freeze
    DOCUMENT_FILE_PATH = 'word/document.xml'.freeze

    # the path of the docx file
    def initialize(path)
      @path = path
      @zip_contents = {}

      Zip::File.open(@path).each do |entry|
        @zip_contents[entry.name] = entry.get_input_stream.read
      end
    end

    def inspect
      "<#{self.class} path: \"#{@path}\">"
    end

    def render_to_file(context, output_path)
      context = Context.new(context)

      Zip::File.open(@path) do |zip_file|
        buffer = Zip::OutputStream.write_buffer do |out|
          @zip_contents.each do |entry_name, stream|
            out.put_next_entry(entry_name)

            case entry_name
            when DOCUMENT_FILE_PATH
              xml_doc = Nokogiri::XML(stream)
              render(xml_doc, context)
              out.write xml_doc.to_xml(indent: 0).gsub("\n".freeze, "".freeze)
            else
              out.write stream
            end
          end
        end

        File.open(output_path, "wb".freeze) {|f| f.write(buffer.string) }
      end
    end

    def render(xml_doc, context)
      xml_doc.xpath(VARIABLE_NODE_PATH, custom_regex_function).each do |node|
        Fragment.new(context).render(node)
      end
    end

    private

    def custom_regex_function
      @custom_regex_function ||= Class.new {
        def regex(node_set, regex_str)
          node_set.find_all { |node| node.text =~ /#{regex_str}/ }
        end
      }.new
    end
  end
end

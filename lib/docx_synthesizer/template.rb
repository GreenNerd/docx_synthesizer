module DocxSynthesizer
  class Template
    VARIABLE_NODE_PATH = %{//w:t[contains(text(), "{{")][contains(text(), "}}")][regex(., "#{Variable::NAME_REGEX.source}")]}.freeze
    DOCUMENT_FILE_PATH = 'word/document.xml'.freeze
    RELS_FILE_PATH = 'word/_rels/document.xml.rels'.freeze
    CONTENT_TYPE_FILE_PATH = '[Content_Types].xml'.freeze

    attr_reader :zip_contents
    attr_accessor :env

    # the path of the docx file
    def initialize(path)
      @path = path
      @zip_contents = {}

      Zip::File.open(@path).each do |entry|
        zip_contents[entry.name] = entry.get_input_stream.read
      end

      @env = Environment.new(self)
      env.relationships = Relationships.new(zip_contents[RELS_FILE_PATH])
    end

    def inspect
      "<#{self.class} path: \"#{@path}\">"
    end

    def render_to_file(hash, output_path)
      process_zip_contents(hash)

      buffer = Zip::OutputStream.write_buffer do |out|
        zip_contents.each do |entry_name, entry_bytes|
          out.put_next_entry(entry_name)
          out.write(entry_bytes)
        end
      end

      File.open(output_path, "wb".freeze) { |f| f.write(buffer.string) }
    end

    def process_zip_contents(hash)
      context = Context.new(hash)

      env.context =  context

      # render document file
      document_xml_doc = Nokogiri::XML(zip_contents[DOCUMENT_FILE_PATH])
      zip_contents[DOCUMENT_FILE_PATH] = render_variables(document_xml_doc, env).to_xml(indent: 0).gsub("\n".freeze, "".freeze)

      # render rels file
      zip_contents[RELS_FILE_PATH] = env.relationships.render.to_xml(indent: 0).gsub("\n".freeze, "".freeze)

      # render content_type file
      xml = ContentType.render(zip_contents[CONTENT_TYPE_FILE_PATH])
      zip_contents[CONTENT_TYPE_FILE_PATH] = xml.to_xml(indent: 0).gsub("\n".freeze, "".freeze)
    end

    private

    def render_variables(xml_doc, env)
      fragment = Fragment.new(env)

      xml_doc.xpath(VARIABLE_NODE_PATH, custom_regex_function).each do |node|
        fragment.render(node)
      end

      xml_doc
    end

    def custom_regex_function
      @custom_regex_function ||= Class.new {
        def regex(node_set, regex_str)
          node_set.find_all { |node| node.text =~ /#{regex_str}/ }
        end
      }.new
    end
  end
end

require 'nokogiri'
require 'zip'

require 'docx_synthesizer/version'

require 'docx_synthesizer/context'
require 'docx_synthesizer/variable'
require 'docx_synthesizer/template'

module DocxSynthesizer
  def self.template(path)
    Template.new(path)
  end
end

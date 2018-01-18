require 'nokogiri'
require 'zip'

require 'docx_synthesizer/version'

require 'docx_synthesizer/context'
require 'docx_synthesizer/template'
require 'docx_synthesizer/variable'

module DocxSynthesizer
  def self.template(path)
    Template.new(path)
  end
end

require 'nokogiri'
require 'zip'

require 'docx_synthesizer/version'

require 'docx_synthesizer/configuration'
require 'docx_synthesizer/util/helper'
require 'docx_synthesizer/util/image_fetcher'

require 'docx_synthesizer/context'
require 'docx_synthesizer/variable'
require 'docx_synthesizer/filter'
require 'docx_synthesizer/environment'
require 'docx_synthesizer/relationships'
require 'docx_synthesizer/styles'
require 'docx_synthesizer/fragment'
require 'docx_synthesizer/processors'
require 'docx_synthesizer/template'

module DocxSynthesizer
  class ImageFetchFailure < StandardError # :nodoc:
  end

  class InvalidTemplateError< StandardError # :nodoc:
  end

  # @param path [String, IO]
  def self.template(path)
    Template.new(path)
  end

  ##
  # Get the configuration or set configuration
  #
  # @return [Configuration]
  #
  # Example:
  #  DocxSynthesizer.configuration do |config|
  #    config.fetch_options = {
  #      read_timeout: 5,
  #      open_timeout: 6,
  #      http_header: {}
  #    }
  #  end
  def self.configuration
    if block_given?
      yield Configuration.instance
    else
      Configuration.instance
    end
  end
end

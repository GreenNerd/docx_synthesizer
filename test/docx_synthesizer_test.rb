require 'test_helper'

class DocxSynthesizerTest < Minitest::Test
  def test_truthy
    assert true
  end

  def test_render
    context = {
      field_1: 1,
      field_2: 'B',
      field_3: [3, 'C'],
      field_4: DocxSynthesizer::Variable::Image.new('image.png', url: 'https://www.baidu.com/img/bd_logo1.png', extname: 'png')
      # field_4: [
      #   DocxSynthesizer::Variable::Image.new('image.jpg', url: '~/image.jpg'),
      #   DocxSynthesizer::Variable::File.new('abc.docx', url: '~/abc.docx'),
      #   4,
      #   'D'
      # ],
      # field_5: DocxSynthesizer::Variable::Image.new('image.jpg', url: '~/image.jpg'),
      # field_6: DocxSynthesizer::Variable::File.new('abc.docx', url: '~/abc.docx')
    }

    template = DocxSynthesizer.template(File.expand_path("../template.docx", __FILE__))
    template.render_to_file(context, File.expand_path("../generated.docx", __FILE__))
  end
end

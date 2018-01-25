require 'test_helper'

class DocxSynthesizerTest < Minitest::Test
  def test_truthy
    assert true
  end

  def test_render
    context = {
      user: {
        name: 'Phil Chen'
      },
      field_1: 1,
      field_2: 'B',
      field_3: [3, 'C'],
      # field_4: DocxSynthesizer::Variable::Image.new('看不见的客人.jpg', url: 'https://img1.doubanio.com/view/activity_page/raw/public/p2638.jpg', extname: 'jpg')
      field_4: [
        DocxSynthesizer::Variable::Image.new('看不见的客人.jpg', url: 'https://img1.doubanio.com/view/activity_page/raw/public/p2638.jpg', extname: 'jpg'),
        DocxSynthesizer::Variable::File.new('Skylark', url: 'https://skylarkly.com'),
        4,
        'D'
      ],
      # field_5: DocxSynthesizer::Variable::Image.new('image.jpg', url: '~/image.jpg'),
      # field_6: DocxSynthesizer::Variable::File.new('abc.docx', url: '~/abc.docx')
    }

    template = DocxSynthesizer.template(File.expand_path("../template.docx", __FILE__))
    template.render_to_file(context, File.expand_path("../generated.docx", __FILE__))
  end
end

require 'test_helper'

class DocxSynthesizerTest < Minitest::Test
  def setup
    @context = {
      user: {
        name: 'Phil Chen'
      },
      field_1: 1,
      field_2: 'B',
      field_3: [3, 'C', '3&C', '3<=>4'],
      # field_4: DocxSynthesizer::Variable::Image.new('看不见的客人.jpg', url: 'https://img1.doubanio.com/view/activity_page/raw/public/p2638.jpg')
      field_4: [
        DocxSynthesizer::Variable::Image.new('看不见的客人.jpg', url: 'https://img1.doubanio.com/view/activity_page/raw/public/p2638.jpg'),
        DocxSynthesizer::Variable::Image.new('base64.jpg', url: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAMAAADWZboaAAAAAXNSR0IArs4c6QAAAeNQTFRFAAAAAAAAAAAAAAAAAAAAKysrJCQkICAgHBw5GhozFy4uKysrJyc7IiIzIDAwLS08Kys5JiYzJCQ9Iy46LCw3Kys1KSkzJyc7Ji85KSk6LS08Kys5KSk3KC88Jy47LS05KS46KC05Kys8KzA6LS08Kys6KS06LS09Ki49Ky85Ky48Ki07LC88Ky48Ky47LC87LTA8LC87Ky08LTA7LC89Ky48Ky47KzA6LS88LC88LS87LC87KzA8LC89LC48KzA7Ky89LS88LDA7LS88LS88LC49LS89Ky87Ky89LS88LC48LDA7LDA9Ky88LS88LS88LDA9LC88LS87LS49LDA8LC88Ky89LS88LDA8LDA8LC88LS88LS48LDA9LC88LDA8LC88LC89LC88LTA8LC88LTA9LC88LDA9LTA8LC89LTA8LS89LC88LDA8LS88LC88LDA9LDA9LS88LC89LDA8LTA8LS89LC88LDA8LDA9LS89LS88LDA8LDA9LC88LDA9LDA8LS88LS89LS89LDA8LC89LS89LS88LDA9LC89LC88LS88LTA8LDA9LDA9LC88LS88LS89LTA9LDA8LC89LS89LTA8LTA8LC89LC89LC88LTA8LTA9LTA9LC88LC88LTA9CeCdSgAAAKB0Uk5TAAECAwQGBwgJCgsMDQ8QERIUFRYXGBkaGx8iJCUmJygsLS8wMzU+P0NHSElMTU5SVVZaW1xeX2BhYmdoa21vcHFydXd4en6BgoOEhYaHiImLjI6PkJGTlJWWmJmam5yhoqSnqq2ws7W2uLu9v8DCxMXGyMnLzM3P0NHS09XW19rc3d7f4OLj5Obn6Onq6+zt7u/w8fP09fb3+Pn6+/z9/ojez5YAAAI/SURBVBgZlcGLX0thAAbgd1srKkJpmUtEF0k0IpeM6E6IdHcpVFQUlXu2kNESs61l5f1T9cPaOX3fOfv2PDCSWlTTM+KZC0fn3z9/2HjECUU51cMR6n1qK7IioZLBZcp8qdsCU2WTNBS8kQtD+UM0FThrhVzVIhMZ3wsJeyflVrwDvb09d5/Oc1XwKASOMcp87SpJw3/ZlfeDZKMFegU+SnhdNuhsPP+ZdyzQypulKHzODkGaO9QFjYwpimYPQGrP5HWssQ1Q9MoBA/YOF2LaKZrbAWNVTvxTStGvIpjJw1/pMxRdg4p6inyZUJAVoOg04uzN755VQKaBIv8GxLWQ/F0MUYqPoiZovOaqFojKKbELGn1cdRyifoomoJU7xpUOCwTWBYpqobc9AxKFlNgHFW6KpqGkm+u9aMqHklHqvS2FKi91rqZAmZ8aEReSsMS4aDmSscS4Y0iKn2vaEGOxQYGXMR47nCdvPZr+HoqS8xPtB60wN8qYS2feUMfrzoSZbpr4cWUbjLlpKnTTASOFTGCxNRty1gUmEry8GVL9TOyb2w6Jw1ThqYAoxUclT/ZD0EA1yx1ZWCcrQEX+U1innsoeO6GTPkNloQs2aJUyCeM7odXOJPw8AQ3bAJPRtwlxGVNMRi008map7rYFWgU+qrpnhZ5jjGqaLFjP3kkF4UrIVC0ykfE9kMsfoqnARRsMlU3SUKR1K0yVDC5T5mOdAwnlVA9HqOftPGSFmtTimt4Rz1w4uvDh5YNm124I/gB5Yv2ErijyZgAAAABJRU5ErkJggg=='),
        DocxSynthesizer::Variable::Hyperlink.new('Skylark', url: 'https://skylarkly.com'),
        4,
        'D'
      ],
      field_5: DocxSynthesizer::Variable::Image.new('douban-reading.jpg', url: 'https://img3.doubanio.com/icon/u113894409-4.jpg'),
      field_6: DocxSynthesizer::Variable::Image.new('cant-load.png', url: 'https://img3.doubanio.com/not-found.png'),
      field_7: [
        DocxSynthesizer::Variable::Hyperlink.new('Escape Link', url: 'https://skylarkly.com?id=1&name=2&age>1&age<2'),
        DocxSynthesizer::Variable::Hyperlink.new('cant-load.png', url: 'https://img3.doubanio.com/not-found.png'),
        DocxSynthesizer::Variable::Hyperlink.new('下载失败', url: 'https://img3.doubanio.com/not-found.png'),
        DocxSynthesizer::Variable::Hyperlink.new('Skylark', url: 'https://skylarkly.com')
      ]
    }
  end

  def test_render
    template = DocxSynthesizer.template(File.expand_path("../template.docx", __FILE__))
    template.render_to_file(@context, File.expand_path("../generated.docx", __FILE__))
  end

  def test_template_with_buffer
    template = DocxSynthesizer.template(File.read(File.expand_path("../template.docx", __FILE__)))
    template.render_to_file(@context, File.expand_path("../generated_from_buffer.docx", __FILE__))
  end

  def test_raise_invalid_template_error
    assert_raises DocxSynthesizer::InvalidTemplateError do
      DocxSynthesizer.template(File.read(File.expand_path("../invalid-template.docx", __FILE__)))
    end
  end
end

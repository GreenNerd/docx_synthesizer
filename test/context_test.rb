require 'test_helper'

class DocxSynthesizerTest < Minitest::Test
  def test_deep_transform
    data = {
      field_1: 1,
      field_2: 'B',
      field_3: [3, 'C']
    }

    context = DocxSynthesizer::Context.new(data)
    assert_kind_of DocxSynthesizer::Variable::Text, context['field_1']
    refute_equal context['field_1'], 1
    context['field_3'].each do |variable|
      assert_kind_of DocxSynthesizer::Variable::Text, variable
    end
  end
end

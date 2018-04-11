require 'benchmark/ips'

require "bundler/setup"
require 'docx_synthesizer'

raw_context_lambda = -> do
  {
    user: {
      name: 'Phil Chen'
    },
    field_1: 1,
    field_2: 'B',
    field_3: [3, 'C', '3&C', '3<=>4'],
    # field_4: DocxSynthesizer::Variable::Image.new('看不见的客人.jpg', url: 'https://img1.doubanio.com/view/activity_page/raw/public/p2638.jpg')
    field_4: [
      DocxSynthesizer::Variable::Image.new('看不见的客人.jpg', url: 'https://images.unsplash.com/photo-1509937991139-724301be9280?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=030053694ccb04e435f5d29d5b24b05b'),
      DocxSynthesizer::Variable::Hyperlink.new('Skylark', url: 'https://skylarkly.com'),
      4,
      'D'
    ],
    field_5: DocxSynthesizer::Variable::Image.new('douban-reading.jpg', url: 'https://assets.skylarkly.com/assets/bg-image-efbe8ee6dc6dc8aa0b381566092728091bda9e8576b61a205a826a52eb044c79.jpg'),
    field_6: DocxSynthesizer::Variable::Image.new('cant-load.png', url: 'https://cdn.dribbble.com/users/515705/screenshots/4204057/dribbble-hipertension.jpg'),
    field_7: [
      DocxSynthesizer::Variable::Hyperlink.new('Escape Link', url: 'https://skylarkly.com?id=1&name=2&age>1&age<2'),
      DocxSynthesizer::Variable::Hyperlink.new('cant-load.png', url: 'https://img3.doubanio.com/not-found.png'),
      DocxSynthesizer::Variable::Hyperlink.new('下载失败', url: 'https://img3.doubanio.com/not-found.png'),
      'Hyperlink'
    ]
  }
end

def threads_on(raw_context)
  DocxSynthesizer.configuration do |config|
    config.threads_on = true
  end

  DocxSynthesizer.template(File.expand_path("../template.docx", __FILE__)).render_to_string(raw_context)
end

def threads_off(raw_context)
  DocxSynthesizer.configuration do |config|
    config.threads_on = false
  end

  DocxSynthesizer.template(File.expand_path("../template.docx", __FILE__)).render_to_string(raw_context)
end

Benchmark.ips do |x|
  x.report("threads off") { threads_off(raw_context_lambda.call) }
  x.report("threads on") { threads_on(raw_context_lambda.call) } # faster

  x.compare!
end

# It may different for the internet
#
# Warming up --------------------------------------
#          threads off     1.000  i/100ms
#           threads on     1.000  i/100ms
# Calculating -------------------------------------
#          threads off      0.343  (± 0.0%) i/s -      2.000  in   5.876670s
#           threads on      0.490  (± 0.0%) i/s -      3.000  in   6.124471s
#
# Comparison:
#           threads on:        0.5 i/s
#          threads off:        0.3 i/s - 1.43x  slower

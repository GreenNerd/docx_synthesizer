# DocxSynthesizer

A Ruby library to generates new Word .docx files based on a template file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docx_synthesizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docx_synthesizer

## Usage

### Variables

- Text
    - All unknown variables are treated as `DocxSynthesizer::Variable::Text`
- Image
    - dimension filter: `dimension:4x4`(inch)
    - background_size filter: `background_size:cover` (cover | contain)
- Hyperlink
- Array


```
require 'docx_synthesizer'

context = {
  username: 'fahchen' 
}
template = DocxSynthesizer.template('template.docx')
template.render_to_file(context, 'output.docx')
# Or
template.render_to_string(context)
```

## Example

- template
![Template](/misc/template.png)
- context
```ruby
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
```

- output
![Output](/misc/output.png)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

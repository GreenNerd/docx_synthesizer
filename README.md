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
- output
![Output](/misc/output.png)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

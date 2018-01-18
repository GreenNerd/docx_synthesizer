
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "docx_synthesizer/version"

Gem::Specification.new do |spec|
  spec.name          = "docx_synthesizer"
  spec.version       = DocxSynthesizer::VERSION
  spec.authors       = ["Phil Chen"]
  spec.email         = ["06fahchen@gmail.com"]

  spec.summary       = %q{Generates new Word .docx file based on a template docx file.}
  spec.homepage      = "https://github.com/GreenNerd/docx_synthesizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency('nokogiri')
  spec.add_runtime_dependency('rubyzip', '>= 1.1.7')


  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marp/version'

Gem::Specification.new do |spec|
  spec.name          = "marp"
  spec.version       = Marp::VERSION
  spec.authors       = ["Taichi Amano"]
  spec.email         = ["pataiji@gmail.com"]

  spec.summary       = %q{Markdown to PDF converter}
  spec.description   = %q{Markdown to PDF converter}
  spec.homepage      = "https://github.com/pataiji/marp/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_dependency 'wkhtmltopdf-binary', '~> 0.9'
  spec.add_dependency 'redcarpet', '~> 3.3'
  spec.add_dependency 'pygments.rb', '~> 0.6'
  spec.add_dependency 'pdfkit', '~> 0.8'
end

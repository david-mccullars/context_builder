# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'context_builder/version'

Gem::Specification.new do |spec|
  spec.name          = "context_builder"
  spec.version       = ContextBuilder::VERSION
  spec.authors       = ["David McCullars"]
  spec.email         = ["david.mccullars@gmail.com"]
  spec.summary       = %q{This gem provides a way of extending modules with context attributes.}
  spec.description   = %q{This gem provides a way of extending modules with context attributes.}
  spec.homepage      = "https://github.com/david-mccullars/context_builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'simplecov', '~> 0.8'
  spec.add_development_dependency 'simplecov-html', '~> 0.8'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
end

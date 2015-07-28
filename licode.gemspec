# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'licode/version'

Gem::Specification.new do |spec|
  spec.name          = "licode"
  spec.version       = Licode::VERSION
  spec.authors       = ["Joshua Rountree"]
  spec.email         = ["joshua@swodev.com"]

  spec.summary       = %q{Ruby gem for working with Licode Services from Ruby}
  spec.description   = %q{This is a ruby gem based on the rb file from the licode repo but with tests and an up to date code base.}
  spec.homepage      = "https://github.com/joshuairl/licode-ruby-sdk"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "addressable", "~> 2.3"
  spec.add_runtime_dependency 'httparty', '~> 0.13', '>= 0.13.1'
  spec.add_runtime_dependency 'activesupport', '~> 2.0'
end

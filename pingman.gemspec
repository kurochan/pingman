# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pingman/version'

Gem::Specification.new do |spec|
  spec.name          = "pingman"
  spec.version       = Pingman::VERSION
  spec.authors       = ["kurochan"]
  spec.email         = ["kuro@kurochan.org"]
  spec.summary       = %q{Ping check tool.}
  spec.description   = %q{Ping check tool.}
  spec.homepage      = "https://github.com/kurochan/pingman"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "net-ping"
  spec.add_runtime_dependency "curses"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end

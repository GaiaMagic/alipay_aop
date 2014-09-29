# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alipay_aop/version'

Gem::Specification.new do |spec|
  spec.name          = "alipay_aop"
  spec.version       = AlipayAop::VERSION
  spec.authors       = ["Hung Yuhei", "Shou Ya"]
  spec.email         = ["kongruxi@gmail.com", "shouyatf@gmail.com"]
  spec.description   = %q{An unofficial API wrapper for Alipay Service Platform}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

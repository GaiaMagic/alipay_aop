# -*- ruby -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alipay_aop/version'

Gem::Specification.new do |spec|
  spec.name          = "alipay_aop"
  spec.version       = AlipayAOP::VERSION
  spec.authors       = ["Shou Ya"]
  spec.email         = ["shouyatf@gmail.com"]
  spec.description   = %q{An unofficial API wrapper for Alipay Open Platform}
  spec.summary       = %q{An unofficial API wrapper for Alipay Open Platform}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activesupport"
end

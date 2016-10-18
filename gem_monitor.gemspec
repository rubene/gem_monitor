# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_monitor/version'

Gem::Specification.new do |spec|
  spec.name          = "gem_monitor"
  spec.version       = GemMonitor::VERSION
  spec.authors       = ["Ruben Estevez"]
  spec.email         = ["ruben.a.estevez@gmail.com"]

  spec.summary       = %q{Crosscheck the gem file versions against ruby gems latest versions and create a report.}
  spec.description   = %q{Crosscheck the gem file versions against ruby gems latest versions and create a report.}
  spec.homepage      = "https://github.com/rubene/gem_monitor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_dependency "colorize"
  spec.add_dependency "railties"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
end

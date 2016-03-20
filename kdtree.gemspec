# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kdtree/version'

Gem::Specification.new do |spec|
  spec.name          = 'kdtree'
  spec.version       = Kdtree::VERSION
  spec.authors       = ['Aaron Franssell']
  spec.email         = ['aaron.franssell@gmail.com']

  spec.summary       = 'My implementation of a 2d k-d tree'
  spec.homepage      = 'https://github.com/aaronFranssell/kdtree'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features)/) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(/^exe/) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rubocop', '0.38.0'
  spec.add_development_dependency 'simplecov', '~> 0.10.0'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
  spec.add_development_dependency 'mocha', '~> 1.1.0'
end

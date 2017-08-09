# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_endpoint/version'

Gem::Specification.new do |spec|
  spec.version       = ActiveEndpoint::VERSION

  spec.name          = 'active_endpoint'
  spec.authors       = ['Marat Khusnetdinov']
  spec.email         = ['marat@khusnetdinov.ru']

  spec.summary       = 'Summary'
  spec.description   = 'Description'
  spec.homepage      = 'https://github.com/khusnetdinov/active_endpoint'
  spec.license       = 'MIT'

  spec.homepage    = 'https://github.com/khusnetdinov/active_endpoint'
  spec.summary     = 'Summary of ActiveEndpoint.'
  spec.description = 'Description of ActiveEndpoint.'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
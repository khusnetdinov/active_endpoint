# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_endpoint/version'

Gem::Specification.new do |spec|
  spec.version = ActiveEndpoint::VERSION

  spec.name = 'active_endpoint'
  spec.authors = ['Marat Khusnetdinov']
  spec.email = ['marat@khusnetdinov.ru']

  spec.summary = 'Your request tracking tool for rails applications'
  spec.description = 'ActiveEndpoint is middleware for Rails applications that collects and analyses requests and responses per request for endpoint. It works with minimal impact on application\'s response time.'
  spec.homepage = 'https://github.com/khusnetdinov/active_endpoint'
  spec.license = 'MIT'

  spec.homepage = 'https://github.com/khusnetdinov/active_endpoint'
  spec.summary = 'Summary of ActiveEndpoint.'
  spec.description = 'Description of ActiveEndpoint.'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.test_files = Dir.glob('spec/**/*')

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'rack'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'activesupport', '>= 3.0.0'
  spec.add_development_dependency 'actionpack', '>= 3.0.0'
  spec.add_development_dependency 'redis-activesupport'
end

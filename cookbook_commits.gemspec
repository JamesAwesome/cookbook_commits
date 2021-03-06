# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cookbook_commits/version'

Gem::Specification.new do |spec|
  spec.name          = 'cookbook_commits'
  spec.version       = CookbookCommits::VERSION
  spec.authors       = ['James Awesome']
  spec.email         = ['james@wesome.nyc']
  spec.summary       = %q{List commits for an organizations cookbooks}
  spec.homepage      = 'https://github.com/jamesawesome/cookbook_commits'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'octokit'
  spec.add_dependency 'thor'
  spec.add_dependency 'colorize'
  spec.add_dependency 'netrc'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end

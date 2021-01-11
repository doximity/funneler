# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funneler/version'

Gem::Specification.new do |spec|
  spec.name = 'funneler'
  spec.version = Funneler::VERSION
  spec.authors = ['Ryan Stawarz']
  spec.email = ['ryan@stawarz.com']

  spec.summary = 'A light-weight approach for routing users through a pre-determined set of routes.'
  spec.description = ''
  spec.homepage = 'https://github.com/doximity/funneler'
  spec.license = 'Apache 2.0'

  spec.files = Dir[
    '.rspec', 'CHANGELOG', 'CONTRIBUTING.md', 'Gemfile', 'Gemfile.lock', 'LICENSE.txt', 'README.md', 'Rakefile',
    'bin/*', 'funneler.gemspec', 'lib/**/*'
  ].select { |f| File.file?(f) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jwt'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sdoc'
  spec.add_development_dependency 'timecop'
end

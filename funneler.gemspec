# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funneler/version'

Gem::Specification.new do |spec|
  spec.name          = "funneler"
  spec.version       = Funneler::VERSION
  spec.authors       = ["Ryan Stawarz"]
  spec.email         = ["ryan@stawarz.com"]

  spec.summary       = %q{A light-weight approach for routing users through a pre-determined set of routes.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/doximity/funneler"
  spec.license       = "Apache 2.0"

  spec.files         = Dir['.rspec', 'CHANGELOG', 'CONTRIBUTING.md', 'Gemfile', 'Gemfile.lock', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin/*', 'funneler.gemspec', 'lib/**/*'].select { |f| File.file?(f) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'jwt'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "pry-byebug"
end

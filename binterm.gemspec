lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'binterm/version'

Gem::Specification.new do |spec|
	spec.name = 'binterm'
	spec.version = BinTerm::VERSION
	spec.authors = ['Aaron Ten Clay']
	spec.email = ['binterm-gem@aarontc.com']

	spec.summary = %q{A simple binary terminal interface for development/troubleshooting.}
	spec.description = %q{A simple binary terminal interface for development/troubleshooting. Proof of concept.}
	spec.homepage = 'https://aarontc.com/projects/binterm'
	spec.license = 'MIT'

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
		`git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	end
	spec.bindir = 'exe'
	spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ['lib']

	spec.add_dependency 'optimist', '~> 3'
	spec.add_dependency 'rubyserial', '~> 0.6'

	spec.add_development_dependency 'bundler', '~> 1.16'
	spec.add_development_dependency 'rake', '~> 13.0'
	spec.add_development_dependency 'minitest', '~> 5.0'
end

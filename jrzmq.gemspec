$:.push File.expand_path("../lib/jrzmq", __FILE__)
require 'version'

Gem::Specification.new do |spec|
  spec.name = "jrzmq"
  spec.version = ZeroMQ::VERSION
  spec.required_rubygems_version = Gem::Requirement.new(">= 1.2") if spec.respond_to?(:required_rubygems_version=)
  spec.authors = [ "outcastgeek" ]
  spec.description = 'ZeroMQ JRuby Bindings using JeroMQ.'
  spec.summary = 'Provides JRuby Bindings to a Pure Java implementation of libzmq (ZeroMQ).'
  spec.email = 'outcastgeek+JRubyZeroMQ@gmail.com'
  spec.executables = [ "jrzmq" ]
  spec.files = %w(.gitignore README.md LICENSE Rakefile Gemfile jrzmq.gemspec)
  spec.files.concat(Dir['bin/*'])
  spec.files.concat(Dir['lib/**/*.rb'])
  spec.files.concat(Dir['jars/**/*.jar'])
  spec.homepage = 'https://github.com/outcastgeek/jrzmq'
  spec.has_rdoc = false
  spec.require_paths = [ "lib" ]
  spec.rubygems_version = '1.3.6'
  spec.add_dependency 'edn', '>= 1.0.0'
  spec.add_development_dependency 'rspec', '~> 2.11.0'
  spec.add_development_dependency 'rake', '~> 10.0.3'
end

# -*- encoding: utf-8 -*-
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warhol/version'

Gem::Specification.new do |gem|
  gem.name          = 'warhol'
  gem.version       = Warhol::VERSION
  gem.summary       = 'A better way to do CanCanCan ability'
  gem.description   = gem.summary
  gem.license       = 'MIT'
  gem.authors       = ['David Stancu']
  gem.email         = 'dstancu@nyu.edu'
  gem.homepage      = 'https://rubygems.org/gems/warhol'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)

  `git submodule --quiet foreach --recursive pwd`.split($INPUT_RECORD_SEPARATOR).each do |submodule|
    submodule.sub!("#{Dir.pwd}/", '')

    Dir.chdir(submodule) do
      `git ls-files`.split($INPUT_RECORD_SEPARATOR).map do |subpath|
        gem.files << File.join(submodule, subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('cancancan')

  gem.add_development_dependency('bundler')
  gem.add_development_dependency('codeclimate-test-reporter')
  gem.add_development_dependency('guard')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('guard-rubocop')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rubocop')
  gem.add_development_dependency('rubygems-tasks')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('yard')
end

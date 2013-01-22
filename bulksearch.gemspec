# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)

require 'bulksearch/version'

Gem::Specification.new do |s|
  s.name        = "bulksearch"
  s.version     = BulkSearch::VERSION
  s.authors     = ["Ben Johnson"]
  s.email       = ["benbjohnson@yahoo.com"]
  s.homepage    = "http://github.com/benbjohnson/bulksearch"
  s.summary     = "Bulk search via spreadsheet."
  s.executables = ['bulksearch']

  s.add_dependency('commander', '~> 4.1.3')
  s.add_dependency('ruby-progressbar', '~> 1.0.2')
  s.add_dependency('spreadsheet', '~> 0.7.6')
  s.add_dependency('binged', '~> 1.1.0')
  s.add_dependency('bossman', '~> 0.4.1')

  s.add_development_dependency('rake', '~> 0.9.2.2')
  s.add_development_dependency('minitest', '~> 3.5.0')
  s.add_development_dependency('mocha', '~> 0.12.5')
  s.add_dependency('unindentable', '~> 0.1.0')

  s.test_files   = Dir.glob("test/**/*")
  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = 'lib'
end

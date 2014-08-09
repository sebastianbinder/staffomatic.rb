# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'staffomatic/version'

Gem::Specification.new do |s|
  s.name = "staffomatic.rb"
  s.version = Staffomatic::VERSION.dup
  s.required_rubygems_version = '>= 1.3.5'
  s.authors = ["Kalle Saas"]
  s.date = "2014-08-09"
  s.description = "A Ruby API wrapper for STAFFOMATIC. Super Simple Employee Scheduling. https://staffomatic.com"
  s.email = "kalle@easypep.de"
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "lib/staffomatic.rb",
    "staffomatic.gemspec",
    "spec/helper.rb",
    "spec/staffomatic_spec.rb"
  ]
  s.homepage = "http://github.com/fluxsaas/staffomatic.rb"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "A Ruby API wrapper for STAFFOMATIC. Super Simple Employee Scheduling. https://staffomatic.com"

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'minitest', '~> 5.4.0'
  s.add_development_dependency 'webmock',  '~> 1.18.0'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-bootstrap/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-assets-bootstrap"
  spec.version       = RailsAssetsBootstrap::VERSION
  spec.authors       = ["rails-assets.org"]
  spec.description   = "The most popular front-end framework for developing responsive, mobile first projects on the web."
  spec.summary       = "The most popular front-end framework for developing responsive, mobile first projects on the web."
  spec.homepage      = "http://getbootstrap.com/"
  spec.license       = "MIT"

  spec.files         = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "rails-assets-jquery", ">= 1.9.1", "< 3"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

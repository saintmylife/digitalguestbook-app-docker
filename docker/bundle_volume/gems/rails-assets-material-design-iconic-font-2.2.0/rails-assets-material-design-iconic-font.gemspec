# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-material-design-iconic-font/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-assets-material-design-iconic-font"
  spec.version       = RailsAssetsMaterialDesignIconicFont::VERSION
  spec.authors       = ["rails-assets.org"]
  spec.description   = "Material Design Iconic Font"
  spec.summary       = "Material Design Iconic Font"
  spec.homepage      = "http://zavoloklom.github.io/material-design-iconic-font"
  spec.licenses      = ["OFL-1.1", "MIT"]

  spec.files         = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

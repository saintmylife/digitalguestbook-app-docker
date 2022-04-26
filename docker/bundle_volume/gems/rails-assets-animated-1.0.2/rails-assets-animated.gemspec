# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-animated/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-assets-animated"
  spec.version       = RailsAssetsAnimated::VERSION
  spec.authors       = ["rails-assets.org"]
  spec.description   = "an animation framework built on animate.css"
  spec.summary       = "an animation framework built on animate.css"
  spec.homepage      = "https://github.com/shri/animated"
  spec.license       = "MIT"

  spec.files         = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "rails-assets-animate.css", "~> 3.2.0"
  spec.add_dependency "rails-assets-jquery", "~> 2.1.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

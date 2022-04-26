# -*- encoding: utf-8 -*-
# stub: rails-assets-bootstrap 3.3.6 ruby lib

Gem::Specification.new do |s|
  s.name = "rails-assets-bootstrap".freeze
  s.version = "3.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["rails-assets.org".freeze]
  s.date = "2016-04-27"
  s.description = "The most popular front-end framework for developing responsive, mobile first projects on the web.".freeze
  s.homepage = "http://getbootstrap.com/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "The most popular front-end framework for developing responsive, mobile first projects on the web.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rails-assets-jquery>.freeze, [">= 1.9.1", "< 3"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rails-assets-jquery>.freeze, [">= 1.9.1", "< 3"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end

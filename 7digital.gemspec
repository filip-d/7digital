# -*- encoding: utf-8 -*-

require File.expand_path('../lib/sevendigital/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "7digital"
  s.version = Sevendigital::VERSION
  s.authors = ["filip7d"]
  s.email = ["filip+ruby@7digital.com"]
  s.description = "A ruby wrapper for 7digital API"
  s.summary = s.description
  s.files = Dir.glob("{lib}/**/*") + %w(README.rdoc)
  s.test_files = Dir.glob("{spec}/**/*") + %w(README.rdoc)
  s.extra_rdoc_files = ["README.rdoc"]
  s.add_dependency('peachy', '>= 0.3.5')
  s.add_dependency('will_paginate', '>= 2.3.15')
  s.add_development_dependency('yard', '>= 0.6.0')
  s.homepage = "http://github.com/filip7d/7digital"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "1.3.6"
end


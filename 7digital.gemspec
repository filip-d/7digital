# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "7digital"
  s.version = '0.0.2'

  s.authors = ["filip7d"]
  s.email = ["filip@7digital.com"]
  s.description = <<DESCRIPTION
A ruby wrapper for 7digital API
DESCRIPTION

  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.rdoc)
  s.extra_rdoc_files = ["README.rdoc"]

  s.homepage = "http://github.com/filip7d/7digital"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "1.3.6"
  s.summary = <<SUMMARY
A ruby wrapper for 7digital API
SUMMARY
end


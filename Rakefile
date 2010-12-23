%w[rubygems rake rake/clean rake/testtask fileutils].each { |f| require f }
$LOAD_PATH << File.dirname(__FILE__) + '/lib'
require 'sevendigital'

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rubygems'
require 'spec/rake/spectask'
require 'rake/rdoctask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--format specdoc'
#  t.rcov = true
end

Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'LICENSE.rdoc', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "7digital Docs"
  rdoc.rdoc_dir = 'doc11/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => :spec

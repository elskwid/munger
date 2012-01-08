require 'rubygems'
# Gem::manage_gems
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

spec = eval(File.new('munger.gemspec','r').read)

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end

desc 'Run specs'
RSpec::Core::RakeTask.new

desc 'Generate coverage reports'
RSpec::Core::RakeTask.new('spec:coverage') do |t|
  t.rcov = true
end

task :doc => [:rdoc]
namespace :doc do
  Rake::RDocTask.new do |rdoc|
    files = ["README", "lib/**/*.rb"]
    rdoc.rdoc_files.add(files)
    rdoc.main = "README"
    rdoc.title = "Munger Docs"
    rdoc.rdoc_dir = "doc"
    rdoc.options << "--line-numbers" << "--inline-source"
  end
end

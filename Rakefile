require 'rake'
require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |spec|
  spec.spec_files = FileList['test/*_spec.rb']
  spec.spec_opts << "--color"
  spec.libs += ["lib", "test"]
end
require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
 
GEM = "gploy"
GEM_VERSION = "0.1.1"
SUMMARY = "Simple gem to configure rails project deploy using git(locaweb server only)"
AUTHOR = "Edipo Luis Federle"
EMAIL = "edipofederle@gmail.com"
HOMEPAGE = "http://edipolf.com"

 
spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['bin', 'lib']
  s.executables = ["gploy"]
  s.add_dependency(%q<rubigen>, [">= 1.3.4"])
  s.files = FileList['bin/*',  'lib/**/*.rb',  '[A-Z]*'].to_a
  
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.rubyforge_project = GEM # GitHub bug, gem isn't being build when this miss
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end
  
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
 
desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end
 
desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gploy}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Edipo Luis Federle"]
  s.date = %q{2010-03-24}
  s.default_executable = %q{gploy}
  s.email = %q{edipofederle@gmail.com}
  s.executables = ["gploy"]
  s.files = ["bin/gploy", "lib/gploy/configure.rb", "lib/gploy/helpers.rb", "lib/gploy.rb", "Rakefile", "README.markdown"]
  s.homepage = %q{http://edipolf.com}
  s.require_paths = ["bin", "lib"]
  s.rubyforge_project = %q{gploy}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Simple gem to configure rails project deploy using git(locaweb server only)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubigen>, [">= 1.3.4"])
    else
      s.add_dependency(%q<rubigen>, [">= 1.3.4"])
    end
  else
    s.add_dependency(%q<rubigen>, [">= 1.3.4"])
  end
end

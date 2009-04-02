# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spotlight}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark G"]
  s.date = %q{2009-04-02}
  s.default_executable = %q{spotlight}
  s.email = %q{spotlight@attackcorp.com}
  s.executables = ["spotlight"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "bin/spotlight", "lib/spotlight", "lib/spotlight/country.rb", "lib/spotlight/data.rb", "lib/spotlight/location.rb", "lib/spotlight.rb", "spec/fixtures", "spec/fixtures/199_246_67_211.xml", "spec/spec_helper.rb", "spec/spotlight_spec.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/attack/spotlight}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

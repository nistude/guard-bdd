Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'guard-bdd'
  s.version           = '0.0.1'
  s.date              = '2012-04-15'
  s.rubyforge_project = 'guard-bdd'

  s.summary     = "An opinionated RSpec and Cucumber runner for guard"
  s.description = "Opinionated guard plugin for BDD workflow with Cucumber and RSpec"

  s.authors  = ["Nikolay Sturm"]
  s.email    = 'sturm@erisiandiscord.de'
  s.homepage = 'http://github.com/nistude/guard-bdd'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency('guard', '~> 1.0')
  s.add_dependency('guard-cucumber', '~> 0.7')
  s.add_dependency('guard-rspec', '~> 0.7')
  s.add_dependency('rspec', '~> 2.9')
  s.add_dependency('state_machine', '~> 1.1')

  #s.add_development_dependency('DEVDEPNAME', [">= 1.1.0", "< 2.0.0"])

  # = MANIFEST =
  s.files = %w[
    Gemfile
    Guardfile
    LICENSE
    README.md
    Rakefile
    doc/flowchart.dia
    guard-bdd.gemspec
    lib/guard/bdd.rb
    lib/guard/bdd/state_machine.rb
    lib/guard/bdd/templates/Guardfile
    spec/unit/state_machine_spec.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  ##s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end

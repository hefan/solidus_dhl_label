# frozen_string_literal: true

require_relative 'lib/solidus_dhl_label/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_dhl_label'
  spec.version = SolidusDhlLabel::VERSION
  spec.authors = ['stefan hartmann']
  spec.email = 'stefan@yo-code.de'

  spec.summary = 'DHL Shipping Label PDF Creation for Solidus Shop'
  spec.description = 'Create a Shipping Label for each completed order using the DHL "Parcel DE Shipping (Post & Parcel Germany)" API'
  spec.homepage = 'https://github.com/hefan/solidus_dhl_label'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hefan/solidus_dhl_label'
  spec.metadata['changelog_uri'] = 'https://github.com/hefan/solidus_dhl_label/blob/master/CHANGELOG.md'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.5', '< 4')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 5']
  spec.add_dependency 'solidus_support', '~> 0.5'
  spec.add_dependency 'deface'

  spec.add_development_dependency 'solidus_dev_support', '~> 2.7'
end

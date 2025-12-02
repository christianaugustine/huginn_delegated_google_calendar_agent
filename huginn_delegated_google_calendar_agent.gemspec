# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "huginn_delegated_google_calendar_agent"
  spec.version       = '0.1.2'
  spec.authors       = ["Christian Augustine"]
  spec.email         = ["me@christianaugustine.com"]

  spec.summary       = "Huginn Delegated Google Calendar Agent"
  spec.description   = "A Google Calendar Agent which supports delegation"

  spec.homepage      = "https://github.com/christianaugustine/huginn_delegated_google_calendar_agent"

  spec.license       = "MIT"


  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.1.0"
  spec.add_development_dependency "rake", "~> 12.3.3"

  spec.add_runtime_dependency "huginn_agent"
end

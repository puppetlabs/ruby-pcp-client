lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pcp-client/version'
Gem::Specification.new do |s|
  s.name        = 'pcp-client'
  s.version     = PCPClient::VERSION
  s.licenses    = ['ASL 2.0']
  s.summary     = "Client library for PCP"
  s.description = "See https://github.com/puppetlabs/pcp-specifications"
  s.homepage    = 'https://github.com/puppetlabs/ruby-pcp-client'
  s.authors     = ["Puppet Labs"]
  s.email       = "puppet@puppetlabs.com"
  s.executables = ["pcp-ping"]
  s.files       = Dir["lib/**/*.rb"]
  s.add_runtime_dependency 'eventmachine', '~> 1.2'
  s.add_runtime_dependency 'faye-websocket', '~> 0.11.0'
  s.add_runtime_dependency 'rschema', '~> 1.3'
end

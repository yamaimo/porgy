lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "porgy/version"

Gem::Specification.new do |spec|
  spec.name          = "porgy"
  spec.version       = Porgy::VERSION
  spec.authors       = ["yamaimo"]
  spec.email         = ["hello@yamaimo.dev"]

  spec.summary       = "Easy PDF Writer"
  spec.homepage      = "https://github.com/yamaimo/porgy"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "prawn"
  spec.add_dependency "redcarpet"
  spec.add_dependency "ox"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
end

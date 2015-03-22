# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "scrapper"
  spec.version       = Scrapper::VERSION
  spec.authors       = ["nyankichi820"]
  spec.email         = ["masafumi.yoshida820@gmail.com"]

  spec.summary       = %q{AppStore Scraping library.}
  spec.description   = %q{AppStore Scraping library.}
  spec.homepage      = "https://github.com/nyankichi820/appcrawler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "oj"
  spec.add_development_dependency "httpclient"
  spec.add_development_dependency "rspec"
end

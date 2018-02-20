# -*- encoding: utf-8 -*-
require File.expand_path('../lib/esendex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors      = ["Adam Bird"]
  gem.email        = ["support@esendex.com"]
  gem.description  = "Send SMS from your application using the Esendex API"
  gem.summary      = "Gem for interacting with the Esendex API"
  gem.homepage     = "http://developers.esendex.com"

  gem.files         = Dir["{app,config,lib}/**/*"]
  gem.test_files    = Dir["spec/**/*"]
  gem.extra_rdoc_files = ["licence.txt", "readme.md"]
  gem.name          = "esendex"
  gem.require_paths = ["lib"]
  gem.version       = Esendex::VERSION
  gem.required_ruby_version = "~> 2.2"
  gem.add_runtime_dependency "nestful", ["~> 0.0.8"]
  gem.add_runtime_dependency "nokogiri", ["~> 1.6.8.1"]
end

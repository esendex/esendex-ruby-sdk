# -*- encoding: utf-8 -*-
require File.expand_path('../lib/esendex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors      = ["Adam Bird"]
  gem.email        = ["support@esendex.com"]
  gem.description  = "Gem for interacting with the Esendex API"
  gem.summary      = "Gem for interacting with the Esendex API"
  gem.homepage     = "http://www.esendex.com"

  gem.files         = Dir["lib/**/*"]
  gem.test_files    = Dir["spec/**/*"]
  gem.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  gem.name          = "esendex"
  gem.require_paths = ["lib"]
  gem.version       = Esendex::VERSION
end

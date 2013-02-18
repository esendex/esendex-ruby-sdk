require 'rake'
require 'rspec'

require "#{Rake.application.original_dir}/lib/esendex"

RSpec.configure do |config|
  config.color = true
end

include Esendex
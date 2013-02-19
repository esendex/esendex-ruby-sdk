require 'rake'
require 'rspec'

require "#{Rake.application.original_dir}/lib/esendex"

RSpec.configure do |config|
  config.color = true
end

include Esendex

def random_string
  (0...24).map{ ('a'..'z').to_a[rand(26)] }.join
end

def random_email
  "#{random_string}@#{random_string}.com"
end

def random_integer
  rand(9999)
end

def random_mobile
  "447#{"%09d" % rand(999999999)}"
end
require 'rake'
require 'rspec'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

require "#{Rake.application.original_dir}/lib/esendex"
include Esendex

RSpec.configure do |config|
  config.color = true
end

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

def random_time
  Time.now + rand(9999)
end
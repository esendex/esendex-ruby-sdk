require 'esendex'
require 'rails'

module Esendex
  class Railtie < Rails::Railtie
    railtie_name :esendex
    puts Dir.pwd

    rake_tasks do
      load "tasks/esendex.rake"
    end
  end
end
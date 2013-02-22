require 'esendex'
require 'rails'

module EsendexPlugin
  class Railtie < Rails::Railtie
    railtie_name :esendex

    rake_tasks do
      load "tasks/esendex.rake"
    end
  end
end
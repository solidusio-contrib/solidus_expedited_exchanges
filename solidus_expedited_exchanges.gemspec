$:.push File.expand_path('../lib', __FILE__)
require 'solidus_expedited_exchanges/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_expedited_exchanges'
  s.version     = SolidusExpeditedExchanges::VERSION
  s.summary     = 'unreturned exchanges extracted from solidus_core'
  s.description = 'unreturned exchanges extracted from solidus_core'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Solidus Developers'
  s.email     = 'contact@solidus.io'
  s.homepage  = 'https://solidus.io/'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus_core', ['>= 2.2.0.alpha', '< 3']

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '0.78.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.10'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'
end

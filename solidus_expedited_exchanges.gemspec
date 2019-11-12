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

  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'solidus_extension_dev_tools'
end

source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch
gem 'solidus_auth_devise', '~> 1.0'

if branch == 'master' || branch >= "v2.3"
  gem 'rails', '~> 5.1.0'
else
  gem 'rails', '~> 5.0.0'
end

gem 'mysql2'
gem 'pg'

gemspec

source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch
gem 'solidus_auth_devise', '~> 1.0'

if branch == 'master' || branch >= "v2.3"
  gem 'rails', '~> 5.1.0'
else
  gem 'rails', '~> 5.0.0'
end

if ENV['DB'] == 'mysql'
  gem 'mysql2'
else
  gem 'pg'
end

group :test do
  gem 'rails-controller-testing'
  if branch < "v2.5"
    gem 'factory_bot', '5.1.1'
  else
    gem 'factory_bot', '5.1.1'
  end
end

gemspec

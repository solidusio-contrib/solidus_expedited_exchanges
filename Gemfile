source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch
gem 'solidus_auth_devise', '~> 1.0'

if branch == 'master' || branch >= "v2.3"
  gem 'rails', '~> 6.0.1'
else
  gem 'rails', '~> 6.0.1'
end

if ENV['DB'] == 'mysql'
  gem 'mysql2'
else
  gem 'pg'
end

group :test do
  gem 'rails-controller-testing'
  if branch < "v2.5"
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end
end

gemspec

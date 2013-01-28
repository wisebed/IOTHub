source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :production do
  gem 'mysql2'
end
group :test do
  gem 'sqlite3'
end
group :production do
  # we want passenger standalone as application server
  gem 'passenger'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'twitter-bootstrap-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby
  gem "less-rails"

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'sorcery', '>= 0.7.13'
gem 'omniauth-github'

# gems needed for activeAdmin
gem 'activeadmin'
gem "meta_search",    '>= 1.1.0.pre'

# for background tasks
gem 'delayed_job_active_record'
gem "daemons"

gem "wisebedclientruby", ">=0.0.50"
gem "simpleblockingwebsocketclient"

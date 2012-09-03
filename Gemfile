source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Force thin to use a more recent version of EventMachine
gem 'eventmachine', '~> 1.0.0.rc.4'

# Prerelease version of thin that builds with -Werror=format-security, the
# default on Debian-based distros.
gem 'thin', git: 'git://github.com/macournoyer/thin'
gem 'sinatra'

gem 'amqp'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'twitter-bootstrap-rails'
  gem 'backbone-on-rails'
end

group :development do
  gem 'foreman'
end

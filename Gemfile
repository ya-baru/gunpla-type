source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop-airbnb'
  gem 'rails_best_practices', require: false
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'brakeman', require: false
  gem 'rails-erd'
  gem 'bullet'
  gem 'better_errors'
  gem 'debug_inspector', '~> 0.0.3'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

# Slim
gem 'slim-rails'
gem 'html2slim'

# Security
gem 'rack-attack'

# Error Notification
gem 'exception_notification'
gem 'slack-notifier'

# User Account
gem 'devise'
gem 'devise-i18n'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

# Admin
gem 'cancancan'
gem 'rails_admin'

# Image
gem 'active_storage_validations'
gem "aws-sdk-s3", require: false
gem 'image_processing'
gem 'mini_magick'

# Markdown
gem 'redcarpet'

# SEO
gem 'gretel'

# Select
gem 'active_hash'

# Category
gem 'ancestry'

# Pagination
gem 'kaminari'

# Search
gem 'ransack'

# Cell
gem 'cells-rails'
gem 'cells-slim'
gem 'rspec-cells'

# Decorator
gem 'draper'

# Count
gem 'counter_culture'

# Ranking
gem "chartkick"

# Map
gem 'geocoder'

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem 'rails', '~> 7.1', '>= 7.1.1'
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"

gem "pundit"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sassc-rails"

gem "devise"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem 'rainbow'
gem "importmap-rails"

group :development, :test do
  gem 'bullet'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "dotenv-rails"

  gem 'rubocop', '~> 1'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'pry-byebug'
  gem 'simplecov'

  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem 'database_cleaner-active_record'
end

group :development do
  gem "web-console"
  gem 'gem_updater', '~> 5'
  gem 'unique_validation_inspector'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

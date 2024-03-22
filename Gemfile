# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'rails', '~> 7.1', '>= 7.1.1'
gem 'sprockets-rails'

gem 'bootsnap', require: false
gem 'jbuilder'
gem 'pundit'
gem 'redis'
gem 'sassc-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'autoprefixer-rails'
gem 'devise'
gem 'font-awesome-sass', '~> 6.1'
gem 'importmap-rails'
gem 'rainbow'
gem 'simple_form', github: 'heartcombo/simple_form'

group :development, :test do
  gem 'bullet'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'

  gem 'panolint'
  gem 'pry-byebug'
  gem 'rubocop', '~> 1'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'simplecov'

  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'gem_updater', '~> 5'
  gem 'unique_validation_inspector'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

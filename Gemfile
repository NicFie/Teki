source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem 'timeout', '~> 0.3.2'

gem "pundit"
gem "jsbundling-rails"
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

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "dotenv-rails"
  gem 'annotate', '~> 3'
  gem 'bullet', '~> 7'
  gem 'ffaker', '~> 2'
  gem 'letter_opener_web', '~> 2'

  gem 'rubocop', '~> 1', require: false
  gem 'rubocop-performance', '~> 1', require: false
  gem 'rubocop-rails', '~> 2', require: false
  gem 'rubocop-rspec', '~> 2', require: false

end

group :development do
  gem "web-console"
  gem 'gem_updater', '~> 5'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'rspec-rails', '~> 6.0.0'
  gem 'simplecov', '~> 0'
  gem 'database_cleaner-active_record'
  gem 'timecop', '~> 0'
  gem 'factory_bot_rails'
  gem 'factory_trace', '~> 1'
  gem 'shoulda-matchers', '~> 5'
  gem 'webmock', '~> 3'
  gem 'vcr', '~> 6.0'
end

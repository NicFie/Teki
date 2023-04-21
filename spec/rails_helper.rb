# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'simplecov_json_formatter'

require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') unless Rails.env.test?

require 'rspec/rails'

# PLUGIN import
require 'support/database_cleaner'
# require 'support/devise'
require 'support/shoulda_matchers'
require 'support/factory_bot'
require 'support/factory_trace'
require 'support/rspec_benchmark'
require 'support/vcr'

DatabaseCleaner.url_allowlist = %w[postgres://postgres:postgres@postgres postgresql://localhost/Teki_Test]

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path               = "#{::Rails.root}/spec/factories"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # devise spec helpers like sign_in
  config.include(Devise::Test::IntegrationHelpers, type: :request)
end

FORMATTERS = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
].freeze

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(FORMATTERS)
SimpleCov.start 'rails' do
add_group 'Serializers', 'app/serializers'
add_group 'Services', 'app/services'
add_group 'Models', 'app/models'
minimum_coverage 100
add_filter '/spec/'
add_filter '/lib'
add_filter '/app/controllers/api/shared'
end

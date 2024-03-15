# frozen_string_literal: true

require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.url_allowlist = [%r{^postgres://postgres:postgres@localhost}, %r{^postgresql://will:teki_password@localhost}, %r{^postgres://rails:password@localhost}]
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction

    DatabaseCleaner.start
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

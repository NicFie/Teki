# frozen_string_literal: true

require 'vcr'

# rubocop:disable Layout/SpaceAroundOperators
VCR.configure do |config|
  config.cassette_library_dir                    = 'spec/vcr/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost                        = true
  config.allow_http_connections_when_no_cassette = true
end
# rubocop:enable Layout/SpaceAroundOperators

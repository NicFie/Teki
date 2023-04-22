require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax                                               = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.max_formatted_output_length                          = 1_000_000
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax                 = :expect
    mocks.verify_partial_doubles = true
  end

  config.raise_errors_for_deprecations!
  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.filter_run_when_matching(:focus)

  config.silence_filter_announcements = true
  config.fail_if_no_examples          = true
  config.warnings                     = false
  config.raise_on_warning             = true
  config.threadsafe                   = true

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order                            = :random
  Kernel.srand(config.seed)
end

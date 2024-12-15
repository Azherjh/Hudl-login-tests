require 'rspec'
require 'dotenv/load'

require 'allure-rspec'

AllureRspec.configure do |config|
  config.results_directory = 'allure-results' # Directory to store test results
  config.clean_results_directory = true      # Clear results directory before each run
  config.logging_level = Logger::INFO         # Set the logging level (optional)
end


RSpec.configure do |config|
  config.before(:suite) do
    Dotenv.load
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Output formatting
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Allow filtering by metadata
  config.filter_run_when_matching :focus

  # Limits the max displayed length of strings in test output
  config.failure_color = :red
  config.tty = true

  # Cleanup after each test run
  config.after(:suite) do
    puts 'Test suite completed!'
  end
end

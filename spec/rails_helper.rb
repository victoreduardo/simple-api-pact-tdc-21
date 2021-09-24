# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'shoulda'
require 'database_cleaner'
# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  DatabaseCleaner.allow_production = false
  DatabaseCleaner.allow_remote_database_url = true
  DatabaseCleaner.clean_with(:truncation)
  DatabaseCleaner.strategy = :transaction

  config.include FactoryBot::Syntax::Methods
  FactoryBot.use_parent_strategy = false

  config.after do
    FactoryBot.rewind_sequences
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec::Matchers.define :have_records do |expected_records|
  records_ids = expected_records.map(&:id).sort
  def response_ids(response)
    response['data']&.map { |d| d['id'].to_i }&.sort || []
  end

  match do |actual_response|
    response_ids(actual_response) == records_ids
  end

  failure_message do |actual_response|
    "expected response data to have records with the following ids #{records_ids}.\n
    ACTUAL | EXPECTED\n
    #{response_ids(actual_response)} | #{records_ids}\n"
  end
end

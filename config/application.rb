require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MetricApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.api_only = true

    config.redis_url = ENV.fetch('REDIS_URL')
    config.cache_store = :redis_cache_store, {
        url: config.redis_url,
        namespace: 'metrics-api',
        expires_in: 1 * 60 * 60, # 1 hour TTL
        race_condition_ttl: 5,

        connect_timeout:    30,  # Defaults to 20 seconds
        read_timeout:       0.2, # Defaults to 1 second
        write_timeout:      0.2, # Defaults to 1 second
        reconnect_attempts: 1   # Defaults to 0
      }

    config.active_record.schema_format = :sql
  end
end

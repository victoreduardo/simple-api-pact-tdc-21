source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'dotenv-rails', '~> 2.7', require: 'dotenv/rails-now'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'rails', '~> 6.1.4.1'
gem 'redis', '~> 4.0'
gem 'validates_timeliness', '~> 5.0.0.alpha3'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker'
  gem 'parallel_tests'
  gem 'rspec'
  gem 'rspec-instafail', require: false
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop', '~> 1.15.0'
  gem 'rubocop-performance'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', '~> 2.4.0'
  gem 'shoulda', '~> 4.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debase', '~> 0.2.4.1'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'ruby-debug-ide', '~> 0.7.2'
end

group :test do
  gem 'database_cleaner-active_record', '~> 1.8'
  gem 'simplecov', '~> 0.17.0'
  gem 'pact', '~> 1.60.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

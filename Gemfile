source 'https://rubygems.org'
ruby "1.9.3"

# Core
gem 'rails', '3.2.13'
gem 'pg'
gem 'nokogiri'
gem "friendly_id", "~> 4.0.9"
gem 'crowdtilt', github: 'msaint/crowdtilt'

# Server
gem 'foreman'
gem 'unicorn'

# Auth
gem 'devise'
gem 'rolify'

# User assets
gem 'paperclip', '~> 3.0'
gem 'ckeditor'
gem 'aws-sdk'

# Site assets
gem 'bootstrap-sass', '2.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Other
gem 'active_model_serializers'
gem "iso_country_codes"

group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'annotate'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "asset_sync"
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
  gem 'capybara'
end

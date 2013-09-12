require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Crowdhoster

  class Application < Rails::Application
    config.assets.paths << Rails.root.join("app", "views", "theme", "assets", "images")
    config.assets.paths << Rails.root.join("app", "views", "theme", "assets", "javascripts")
    config.assets.paths << Rails.root.join("app", "views", "theme", "assets", "stylesheets")

    config.multisite_enabled = ENV['MULTISITE_ENABLED'].nil? ? false : ENV['MULTISITE_ENABLED'].downcase == 'true'

    # This is the main domain of the app, and is how the app determines 
    # custom domains vs subdomains in a multisite deployment.
    #
    # It should be overwritten in the environment-specific config files 
    # but a default is set here to prevent errors. Don't change this value here!
    config.central_domain = 'crowdhoster.dev'

    config.crowdhoster_app_name = ENV['APP_NAME'] || 'crowdhoster_anonymous'

    #Crowdtilt API key/secret
    config.crowdtilt_sandbox_key = ENV['CROWDTILT_SANDBOX_KEY']
    config.crowdtilt_sandbox_secret = ENV['CROWDTILT_SANDBOX_SECRET']
    config.crowdtilt_production_key = ENV['CROWDTILT_PRODUCTION_KEY']
    config.crowdtilt_production_secret = ENV['CROWDTILT_PRODUCTION_SECRET']

    # --- Standard Rails Config ---
    config.time_zone = 'GMT'
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_record.whitelist_attributes = true
    # Enable the asset pipeline
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    # --- Standard Rails Config ---

    #loading for ckeditor
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
    config.autoload_paths += %W(#{config.root}/lib/constraints)
    config.autoload_paths += %W(#{config.root}/lib/extensions)

    #Fix for getting Devise to work on Heroku deploy
    #Forcing app to not access the DB or models when precompiling
    config.assets.initialize_on_precompile = false

    #Paperclip default options
    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        access_key_secret: ENV['AWS_SECRET_ACCESS_KEY']
      },
      path: "/#{ENV['APP_NAME']}/uploads/:class/:attachment/:id_partition/:style.:extension",
      bucket: ENV['AWS_BUCKET'],
      s3_protocol: 'https',
      default_url: '/images/missing_:style.jpg'
    }

    #Mailgun options
    config.action_mailer.smtp_settings = {
       :authentication => :plain,
       :address => "smtp.mailgun.org",
       :port => 587,
       :domain => ENV['MAILGUN_DOMAIN'],
       :user_name => ENV['MAILGUN_USERNAME'],
       :password => ENV['MAILGUN_PASSWORD']
      }

    config.processing_fee = 2.9

  end
end

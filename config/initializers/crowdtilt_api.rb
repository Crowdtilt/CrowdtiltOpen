module Crowdtilt

  def self.sandbox
    self.configure api_key: Rails.configuration.crowdtilt_sandbox_key,
                   api_secret: Rails.configuration.crowdtilt_sandbox_secret,
                   mode: 'sandbox'
  end

  def self.production(settings)
    self.configure api_key: settings.ct_prod_api_key,
                      api_secret: settings.ct_prod_api_secret,
                      mode: 'production'
  end

end

# Initialize sandbox mode by default
Crowdtilt.sandbox

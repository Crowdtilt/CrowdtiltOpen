class ImportCtKeysFromEnv < ActiveRecord::Migration
  def up
    # Import CROWDTILT_PRODUCTION_KEY and CROWDTILT_PRODUCTION_SECRET from .env
    say_with_time "Importing Crowdtilt keys from .env" do
      Settings.reset_column_information

      # If there is a settings object with guest and admin IDs, 
      # the site was already initialized with the Crowdtilt API
      if @settings = Settings.first
        if @settings.ct_production_guest_id && @settings.ct_production_admin_id
          @settings.update_attribute(:ct_prod_api_key, ENV['CROWDTILT_PRODUCTION_KEY'])
          @settings.update_attribute(:ct_prod_api_secret, ENV['CROWDTILT_PRODUCTION_SECRET'])
        end
      end

    end
  end

  def down
  end
end

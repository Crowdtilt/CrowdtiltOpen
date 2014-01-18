namespace :ch do

  # To run this rake task, you'll need to specify a campaign ID as well as which rails environment you are targeting
  # Example:
  # $ foreman run rake ch:sync_crowdtilt_payments CAMPAIGN_ID=CMP3A7758DE00B911E38B6F99339B09C131 RAILS_ENV=production

  desc "Synchronize payment data on the API with the local payment data"
  task :sync_crowdtilt_payments => :environment do
    campaign = Campaign.find_by_ct_campaign_id(ENV['CAMPAIGN_ID'])
    if campaign
      puts "Synching payments for #{campaign.name} (#{ENV['CAMPAIGN_ID']})"
      campaign.production_flag ? Crowdtilt.production(Settings.first) : Crowdtilt.sandbox
      begin
        response = Crowdtilt.get("campaigns/#{campaign.ct_campaign_id}/payments?page=1&per_page=100")
      rescue => exception
        puts exception.message and abort
      end      
      ct_payments = response['payments']
      pages = response['pagination']['total_pages']

      counter = 1

      for x in 1..pages
        if x > 1
          begin
            response = Crowdtilt.get("campaigns/#{campaign.ct_campaign_id}/payments?page=#{x}&per_page=100")
          rescue => exception
            puts exception.message and abort
          end
          ct_payments = response['payments']
        end

        ct_payments.each do |ct_payment|
          puts "#{counter}: Synching payment #{ct_payment['id']} | Status: #{ct_payment['status']}"
          payment = Payment.find_by_ct_payment_id(ct_payment['id'])
          if payment
            payment.update_attribute(:status, ct_payment['status'])
            counter+=1
          else
            puts "Payment not found (#{ct_payment['id']})"
          end
        end
      end
    else
      puts "Campaign Not Found (#{ENV['CAMPAIGN_ID']})"
    end
  end

end

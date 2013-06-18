class AdminController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!
  before_filter :verify_admin
  
  def admin_website
    #Handle the form submission if request is PUT
    if request.put?
      if @settings.update_attributes(params[:settings])
        flash.now[:success] = "Website settings successfully updated!"
      else
        message = ''
      	@settings.errors.each do |key, error|
        	message = message + key.to_s.humanize + ' ' + error.to_s + ', '
      	end
     		flash.now[:error] = message[0...-2]
      end    
    end
  end  
  
  def admin_bank_setup
    @bank = {}
    begin
    	Crowdtilt.production
    	response = Crowdtilt.get('/users/' + @settings.ct_production_admin_id + '/banks/default')
    rescue => exception # response threw an error, default bank may not be set up
			if request.post?
				if params[:ct_bank_id].blank?
	        flash.now[:error] = "An error occurred, please try again"
	        return
	      else
	        begin
	          bank = {
	            id: params[:ct_bank_id]
	          }
	          Crowdtilt.production
	          response = Crowdtilt.post('/users/' + @settings.ct_production_admin_id + '/banks/default', {bank: bank})
	        rescue => exception
	          flash.now[:error] = exception.to_s
	          return
	        else
	          @bank = response['bank']
	        end
	    	end
      end
    else # response is good, check for default bank
    	if response['bank'] # default bank is already set up
    		@bank = response['bank']
    	else
    		flash.now[:error] = "An error occurred, please try again"
    	end
    end
  end
  
  def ajax_verify
    if params[:name].blank? || params[:phone].blank? || params[:street_address].blank? || params[:postal_code].blank? || params[:dob].blank?
      render text: "error" #not all fields filled out
    else
      begin
      	Crowdtilt.production
      	response = Crowdtilt.get('/users/' + @settings.ct_production_admin_id)
      rescue => exception
          render text: "error" #failed to verify through Crowdtilt API
          return
      end   
      if response['user']['is_verified'] != 1     
        begin
          verification = {
            name: params[:name],
            phone_number: params[:phone],
            street_address: params[:street_address],
            postal_code: params[:postal_code],
            dob: params[:dob]
          }                      
          Crowdtilt.production
          response = Crowdtilt.post('/users/' + @settings.ct_production_admin_id + '/verification', {verification: verification})                     
        rescue => exception
          render text: "error" #failed to verify through Crowdtilt API
        else
          render text: "success" #successfully verified through Crowdtilt API
        end
      else
        render text: "success"  #already verified
      end    
    end
  end

end
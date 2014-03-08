module CheckoutMixin

  def calculate_processing_fee(amount_cents)
    amount_cents *= Rails.configuration.processing_fee_percentage.to_f / 100
    amount_cents += Rails.configuration.processing_fee_flat_cents
    amount_cents.ceil
  end

  def reward_choice_validates?(reward, campaign, payment_in_cents)
    reward && reward.campaign_id == campaign.id && payment_in_cents >= reward.price && !reward.sold_out?
  end

  # create simple payment hash from params. does not include fees/payment amounts/cc info.
  # to be used in response to javascript payment-creation requests (eg checkout_process and checkout_error)
  def basic_payment_info(params)
    info = {
        client_timestamp: params.has_key?(:client_timestamp) ? params[:client_timestamp].to_i : nil,
        ct_tokenize_request_id: params[:ct_tokenize_request_id],
        fullname: params[:fullname],
        email: params[:email],
        billing_postal_code: params[:billing_postal_code],
        quantity: params[:quantity].to_i,

        #Shipping Info
        address_one: params.has_key?(:address_one) ? params[:address_one] : '',
        address_two: params.has_key?(:address_two) ? params[:address_two] : '',
        city: params.has_key?(:city) ? params[:city] : '',
        state: params.has_key?(:state) ? params[:state] : '',
        postal_code: params.has_key?(:postal_code) ? params[:postal_code] : '',
        country: params.has_key?(:country) ? params[:country] : '',
        additional_info: params.has_key?(:additional_info) ? params[:additional_info] : ''
    }

    info[:amount] = (params[:amount].to_f*100).ceil if params[:amount]
    info[:ct_user_id] = params[:ct_user_id] if params[:ct_user_id]

    info
  end
end
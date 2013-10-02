module CampaignsHelper

  def short_price(price)
    number_with_precision(price, precision: (price*100%100==0.0 ? 0 : 2))
  end
end

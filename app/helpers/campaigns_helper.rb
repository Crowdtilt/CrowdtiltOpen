module CampaignsHelper

  def short_price(price, currency_symbol='', precision=nil)
    precision ||= (price*100%100==0.0 ? 0 : 2)
    "#{currency_symbol}#{number_with_precision(price, delimiter: ",", precision: precision)}"
  end
end

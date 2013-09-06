class UserMailer < ActionMailer::Base

  def payment_confirmation(payment, campaign)
    @site = Site.find_by_id(1)
    @payment = payment
    @campaign = campaign
    mail from: "#{@site.site_name} <#{@site.reply_to_email}>", reply_to: @site.reply_to_email, to: @payment.email, subject: "Your confirmation for #{@campaign.name}"
  end

end
